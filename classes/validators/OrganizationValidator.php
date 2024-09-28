<?php

use AbstractBootstrapItaliaInputValidator;
use eZHTTPFile;

class OrganizationValidator extends AbstractBootstrapItaliaInputValidator
{
    const ORGANIZATION_IN_STRUCTURE_ERROR_TEXT = '<strong>%s</strong>: i valori selezionati non comprendono alcuna struttura';

    public function validate(): array
    {
        if ($this->class->attribute('identifier') == 'organization') {
            $isStructure = false;
            $isOrganization = false;

            $audienceName = 'audience';
            $accessibilityName = 'accessibility';
            $geoName = 'geo';
            $mainFunctionName = 'main_function';
            $typeName = 'type';

            $hasType = $hasAudience = $hasAccessibility = $hasGeo = $hasMainFunction = false;

            foreach ($this->contentObjectAttributes as $contentObjectAttribute) {
                $contentClassAttribute = $contentObjectAttribute->contentClassAttribute();
                if ($contentClassAttribute->attribute('identifier') == 'type') {
                    $typeName = $contentClassAttribute->attribute('name');
                    $tagContent = $this->getTags($contentObjectAttribute);
                    if ($tagContent instanceof eZTags) {
                        foreach ($tagContent->tags() as $tag) {
                            $tagType = ObjectHandlerServiceContentAslOrganization::getTagType($tag);
                            if ($tagType === ObjectHandlerServiceContentAslOrganization::ORGANIZATION_TYPE) {
                                $isOrganization = true;
                            }
                            if ($tagType === ObjectHandlerServiceContentAslOrganization::STRUCTURE_TYPE) {
                                $isStructure = true;
                            }
                            $hasType = true;
                        }
                    }
                }
                if ($contentClassAttribute->attribute('identifier') == 'audience') {
                    $audienceName = $contentClassAttribute->attribute('name');
                    $hasAudience = $this->hasText($contentObjectAttribute);
                }
                if ($contentClassAttribute->attribute('identifier') == 'accessibility') {
                    $accessibilityName = $contentClassAttribute->attribute('name');
                    $hasAccessibility = $this->hasText($contentObjectAttribute);
                }
                if ($contentClassAttribute->attribute('identifier') == 'geo') {
                    $geoName = $contentClassAttribute->attribute('name');
                    $hasGeo = $this->hasGeo($contentObjectAttribute);
                }
                if ($contentClassAttribute->attribute('identifier') == 'main_function') {
                    if ($contentClassAttribute->attribute('is_required')) {
                        $hasMainFunction = true;
                    } else {
                        $mainFunctionName = $contentClassAttribute->attribute('name');
                        $hasMainFunction = $this->hasText($contentObjectAttribute);
                    }
                }
            }

            $violations = [];
            if ($isStructure) {
                if (!$hasAudience) {
                    $violations[] = [
                        'identifier' => 'audience',
                        'text' => $this->getViolationText($audienceName),
                    ];
                }
                if (!$hasAccessibility) {
                    $violations[] = [
                        'identifier' => 'accessibility',
                        'text' => $this->getViolationText($accessibilityName),
                    ];
                }
                if (!$hasGeo) {
                    $violations[] = [
                        'identifier' => 'geo',
                        'text' => $this->getViolationText($geoName),
                    ];
                }
            }

            if ($isOrganization) {
                if (!$hasMainFunction) {
                    $violations[] = [
                        'identifier' => 'main_function',
                        'text' => $this->getViolationText($mainFunctionName),
                    ];
                }
            }

            try {
                $this->checkStructureAssignment($isStructure);
            }catch (InvalidArgumentException $e){
                if ($hasType) {
                    $violations[] = [
                        'identifier' => 'type',
                        'text' => sprintf(self::ORGANIZATION_IN_STRUCTURE_ERROR_TEXT, $typeName),
                    ];
                }
            }

            if (!empty($violations)) {
                return [
                    'items' => $violations,
                ];
            }
        }

        return [];
    }

    private function getViolationText($name)
    {
        return sprintf('<strong>%s</strong>: %s', $name, ezpI18n::tr('kernel/classes/datatypes', 'Input required.'));
    }

    private function checkStructureAssignment(bool $isStructure)
    {
        $structureContainer = eZContentObject::fetchByRemoteID(
            ObjectHandlerServiceContentAslOrganization::STRUCTURE_CONTAINER_REMOTE_ID
        );
        if (!$structureContainer instanceof eZContentObject) {
            return;
        }
        $structureContainerNodeId = $structureContainer->mainNodeID();
        $structureNodeAssignment = false;
        /** @var eZNodeAssignment[] $nodeAssignments */
        $nodeAssignments = $this->version->nodeAssignments();
        foreach ($nodeAssignments as $nodeAssignment) {
            if ($nodeAssignment->attribute('parent_node') == $structureContainerNodeId) {
                $structureNodeAssignment = $nodeAssignment;
            }
        }

        if ($isStructure) {
            if (!$structureNodeAssignment) {
                $this->version->assignToNode($structureContainerNodeId);
            }elseif ($structureNodeAssignment->isRemoveOperation()){
                $structureNodeAssignment->setAttribute('op_code', eZNodeAssignment::OP_CODE_CREATE);
                $structureNodeAssignment->store();
            }
        } elseif ($structureNodeAssignment) {
            if (count($nodeAssignments) == 1){
                throw new InvalidArgumentException();
            }
            $this->version->removeAssignment($structureContainerNodeId);
        }
    }
}