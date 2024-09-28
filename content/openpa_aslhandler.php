<?php

class openpa_aslHandler extends openpa_bootstrapitaliaHandler
{
    /**
     * @param eZHTTPTool $http
     * @param eZModule $module
     * @param eZContentClass $class
     * @param eZContentObject $object
     * @param eZContentObjectVersion $version
     * @param eZContentObjectAttribute[] $contentObjectAttributes
     * @param int $editVersion
     * @param string $editLanguage
     * @param string $fromLanguage
     * @param array $validationParameters
     * @return array
     */
    function validateInput(
        $http,
        &$module,
        &$class,
        $object,
        &$version,
        $contentObjectAttributes,
        $editVersion,
        $editLanguage,
        $fromLanguage,
        $validationParameters
    ) {
        $base = 'ContentObjectAttribute';
        return parent::validateInput(
            $http,
            $module,
            $class,
            $object,
            $version,
            $contentObjectAttributes,
            $editVersion,
            $editLanguage,
            $fromLanguage,
            $validationParameters
        );
    }
}
