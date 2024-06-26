<?php

class OpenPAAslOperators
{

    function operatorList()
    {
        return [
            'parse_organization_as_structure_attribute_groups',
        ];
    }

    function namedParameterPerOperator()
    {
        return true;
    }

    function namedParameterList()
    {
        return [
            'parse_organization_as_structure_attribute_groups' => [
                'object' => ['type' => 'array', 'required' => true],
                'show_all' => ['type' => 'boolean', 'required' => false, 'default' => false],
            ],
        ];
    }

    function modify(
        $tpl,
        $operatorName,
        $operatorParameters,
        $rootNamespace,
        $currentNamespace,
        &$operatorValue,
        $namedParameters
    ) {
        switch ($operatorName) {
            case 'parse_organization_as_structure_attribute_groups':
                $operatorValue = self::parseAttributeGroups($namedParameters['object'], $namedParameters['show_all']);
                break;
        }
    }

    private static function parseAttributeGroups($object, $showAll = false)
    {
        if (!$object instanceof eZContentObject) {
            return [];
        }

        $items = [];
        $contentClass = eZContentClass::fetchByIdentifier('edit_organization_as_structure');
        if (!$contentClass instanceof eZContentClass) {
            return $items;
        }
        $dataMap = $object->dataMap();
        $extraManager = OCClassExtraParametersManager::instance($contentClass);
        $attributeGroups = $extraManager->getHandler('attribute_group');
        $openpa = OpenPAObjectHandler::instanceFromObject($object);

        $tableView = $extraManager->getHandler('table_view');
        $hiddenList = $attributeGroups->attribute('hidden_list');
        if ($showAll) {
            foreach ($dataMap as $identifier => $attribute) {
                if ($openpa->hasAttribute($identifier)) {
                    $openpaAttribute = $openpa->attribute($identifier);
                    if ($openpaAttribute->attribute('has_content')
                        || $openpaAttribute->attribute('full')['show_empty']
                    ) {
                        if (!self::getDeepHasContent($openpaAttribute, $identifier, $tableView)) {
                            continue;
                        }
                        $items[] = [
                            'slug' => $identifier,
                            'title' => $openpa->attribute($identifier)->attribute('label'),
                            'label' => $openpa->attribute($identifier)->attribute('label'),
                            'attributes' => [$openpa->attribute($identifier)],
                            'is_grouped' => false,
                            'wrap' => false,
                            'evidence' => false,
                            'data_element' => false,
                        ];
                    }
                }
            }
        } elseif ($attributeGroups->attribute('enabled')) {
            foreach ($attributeGroups->attribute('group_list') as $slug => $name) {
                if (count($attributeGroups->attribute($slug)) > 0) {
                    $attributes = [];
                    $wrapped = true;
                    foreach ($attributeGroups->attribute($slug) as $identifier) {
                        if ($openpa->hasAttribute($identifier)) {
                            $openpaAttribute = $openpa->attribute($identifier);
                            if (!$openpaAttribute->attribute('full')['exclude']
                                && ($openpaAttribute->attribute('has_content') || $openpaAttribute->attribute(
                                        'full'
                                    )['show_empty'])) {
                                if (!self::getDeepHasContent($openpaAttribute, $identifier, $tableView)) {
                                    continue;
                                }

                                $attributes[] = $openpaAttribute;
                                if ($wrapped && (!$openpaAttribute->attribute(
                                            'full'
                                        )['show_link'] || $openpaAttribute->attribute('full')['show_label'])) {
                                    $wrapped = false;
                                }
                            }
                        }
                    }
                    if (count($attributes)) {
                        $items[] = [
                            'slug' => $slug,
                            'title' => $attributeGroups->attribute('current_translation')[$slug],
                            'label' => in_array($slug, $hiddenList) ? false : $attributeGroups->attribute(
                                'current_translation'
                            )[$slug],
                            'attributes' => $attributes,
                            'is_grouped' => true,
                            'wrap' => $wrapped && count($attributes) > 1,
                            'evidence' => in_array($slug, $attributeGroups->attribute('evidence_list')),
                            'data_element' => $attributeGroups->attribute('translations')[$slug]['ita-PA'] ?? false,
                        ];
                    }
                }
            }
        } else {
            foreach ($tableView->attribute('show') as $identifier) {
                if ($openpa->hasAttribute($identifier)) {
                    $openpaAttribute = $openpa->attribute($identifier);
                    if (!$openpaAttribute->attribute('full')['exclude']
                        && ($openpaAttribute->attribute('has_content')
                            || $openpaAttribute->attribute('full')['show_empty']
                        )
                    ) {
                        if (!self::getDeepHasContent($openpaAttribute, $identifier, $tableView)) {
                            continue;
                        }
                        $items[] = [
                            'slug' => $identifier,
                            'title' => $openpa->attribute($identifier)->attribute('label'),
                            'label' => $openpa->attribute($identifier)->attribute('label'),
                            'attributes' => [$openpaAttribute],
                            'is_grouped' => false,
                            'wrap' => false,
                            'evidence' => false,
                            'data_element' => false,
                        ];
                    }
                }
            }
        }

        return [
            'has_items' => count($items) > 0,
            'show_index' => count($items) > 1 && !$attributeGroups->attribute('hide_index'),
            'items' => $items,
        ];
    }

    private static function getDeepHasContent($openpaAttribute, $identifier, $tableView): bool
    {
        if ($openpaAttribute->attribute('full')['show_empty']) {
            return true;
        }

        if (
            // workaround per ezboolean
            (
                $openpaAttribute->hasAttribute('contentobject_attribute')
                && $openpaAttribute->attribute('contentobject_attribute')->attribute('data_type_string') == eZBooleanType::DATA_TYPE_STRING
                && $openpaAttribute->attribute('contentobject_attribute')->attribute('data_int') != '1'
            )
            ||
            // workaround per ezxmltext
            (
                $openpaAttribute->hasAttribute('contentobject_attribute')
                && $openpaAttribute->attribute('contentobject_attribute')
                    ->attribute('data_type_string') == eZXMLTextType::DATA_TYPE_STRING
                && trim(
                    $openpaAttribute->attribute('contentobject_attribute')->content()
                        ->attribute('output')
                        ->attribute('output_text')
                ) == ''
            )
            ||
            // evita di duplicare l'immagine principale nella galleria
            (
                in_array($identifier, $tableView->attribute('main_image'))
                && !in_array($identifier, $tableView->attribute('show_link'))
                && $openpaAttribute->hasAttribute('contentobject_attribute')
                && $openpaAttribute->attribute('contentobject_attribute')->attribute('data_type_string') == eZObjectRelationListType::DATA_TYPE_STRING
                && count($openpaAttribute->attribute('contentobject_attribute')->attribute('content')['relation_list']) <= 1
            )
        ){
            return false;
        }

        return true;
    }
}
