<?php

class ObjectHandlerServiceContentAslOrganization extends ObjectHandlerServiceBase
{
    const STRUCTURE_TYPE = 'structure';

    const ORGANIZATION_TYPE = 'organization';

    const CLASS_IDENTIFIER = 'organization';

    const STRUCTURE_CONTAINER_REMOTE_ID = 'all-structures';

    const ORGANIZATION_CONTAINER_REMOTE_ID = 'management';

    const STRUCTURE_TAG_CONTAINER_REMOTE_ID = '1227c1bef6b787b8ac584f3806c6a167';

    const ORGANIZATION_TAG_CONTAINER_REMOTE_ID = 'd2a46e44a1634e5108ed4c9b40fd84a1';

    private $isStructure = false;

    private $isOrganization = false;

    private $tagsByType = [
        self::STRUCTURE_TYPE => [],
        self::ORGANIZATION_TYPE => [],
    ];

    /**
     * @var eZContentObjectTreeNode
     */
    private $structureAssignment;

    private $structuresRoot;

    /**
     * @var eZContentObjectTreeNode
     */
    private $organizationAssignment;

    function run()
    {
        if ($this->container->getContentObject()->attribute('class_identifier') === self::CLASS_IDENTIFIER) {
            $this->isValid = true;
            $parent = $this->container->getContentNode()->fetchParent();
            if ($parent->object()->remoteID() === self::STRUCTURE_CONTAINER_REMOTE_ID) {
                $this->isStructure = true;
            } else {
                $this->isOrganization = true;
            }

            $nodeAssignments = $this->container->getContentObject()->assignedNodes();
            foreach ($nodeAssignments as $assignment) {
                $parent = $assignment->fetchParent();
                if ($parent->object()->remoteID() === self::STRUCTURE_CONTAINER_REMOTE_ID) {
                    $this->structuresRoot = $parent;
                    $this->structureAssignment = $assignment;
                } else {
                    $this->organizationAssignment = $assignment;
                }
            }
        }
        $this->fnData['structure_types'] = 'getStructureTypes';
        $this->data['is_organization'] = $this->isOrganization;
        $this->data['organization_node'] = $this->organizationAssignment;
        $this->data['is_structure'] = $this->isStructure;
        $this->data['structure_node'] = $this->structureAssignment;
    }

    public function getStructureTypes(): array
    {
        if (!$this->isStructure) {
            return [];
        }
        $this->loadTypeTags();
        return $this->tagsByType[self::STRUCTURE_TYPE];
    }

    public static function getTagType(eZTagsObject $tag): string
    {
        if ($tag->getParent()->attribute('remote_id') === self::STRUCTURE_TAG_CONTAINER_REMOTE_ID) {
            return self::STRUCTURE_TYPE;
        }
        if ($tag->getParent()->attribute('remote_id') === self::ORGANIZATION_TAG_CONTAINER_REMOTE_ID) {
            return self::ORGANIZATION_TYPE;
        }

        return 'unknown';
    }

    private function loadTypeTags()
    {
        if (
            empty($this->tagsByType[self::STRUCTURE_TYPE])
            && empty($this->tagsByType[self::ORGANIZATION_TYPE])
        ) {
            if (isset($this->container->attributesHandlers['type'])
                && $this->container->attributesHandlers['type']
                    ->attribute('contentobject_attribute')
                    ->attribute('data_type_string') === eZTagsType::DATA_TYPE_STRING) {
                /** @var eZTags $tags */
                $tagsContent = $this->container->attributesHandlers['type']
                    ->attribute('contentobject_attribute')
                    ->content();
                $tags = [];
                if (is_array($tagsContent->attribute('tag_ids')) && !empty($tagsContent->attribute('tag_ids'))) {
                    $params = ['id' => [$tagsContent->attribute('tag_ids')]];
                    $customConds = eZTagsObject::fetchCustomCondsSQL($params, false, false);
                    $tagsList = eZTagsObject::fetchObjectList(
                        eZTagsObject::definition(),
                        [],
                        $params,
                        null,
                        null,
                        false,
                        false,
                        [
                            'DISTINCT eztags.*',
                            ['operation' => 'eztags_keyword.keyword', 'name' => 'keyword',],
                            ['operation' => 'eztags_keyword.locale', 'name' => 'locale',],
                        ],
                        ['eztags_keyword'],
                        $customConds
                    );
                    foreach ($tagsList as $item) {
                        $tags[array_search($item['id'], $tagsContent->attribute('tag_ids'))] = new AslTagObject($item);
                    }
                }
                ksort($tags);

                foreach ($tags as $tag) {
                    $type = self::getTagType($tag);
                    $this->tagsByType[$type][] = $tag;
                    if ($type == self::STRUCTURE_TYPE) {
                        $tag->setContainerNode($this->structuresRoot);
                    }
                }
            }
        }
    }
}

class AslTagObject extends eZTagsObject
{
    private $containerNode;

    public function getContainerNode()
    {
        return $this->containerNode;
    }

    public function setContainerNode($containerNode): void
    {
        $this->containerNode = $containerNode;
    }

    public function getUrl($clean = false)
    {
        if ($this->getContainerNode() instanceof eZContentObjectTreeNode) {
            return rtrim($this->getContainerNode()->attribute('url_alias'), '/')
                . '/(view)/' . rawurlencode($this->attribute('keyword'));
        }

        return parent::getUrl($clean);
    }

}