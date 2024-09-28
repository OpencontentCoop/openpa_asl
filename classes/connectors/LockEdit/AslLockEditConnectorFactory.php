<?php

use Opencontent\Ocopendata\Forms\Connectors\OpendataConnector\ClassConnectorFactory;
use Opencontent\Ocopendata\Forms\Connectors\OpendataConnector\ClassConnectorInterface;
use Opencontent\Opendata\Api\Values\Content;

class AslLockEditConnectorFactory
{
    public static function load(eZContentObject $object, $helper, $locale): ClassConnectorInterface
    {
        $classConnectorName = false;
        $prefixClassConnectorName = 'Asl';
        $baseClassConnectorName = 'LockEditClassConnector';

        $byRemoteConnectorName = $prefixClassConnectorName . self::toCamelCase($object->attribute('remote_id')) . $baseClassConnectorName;
        if (class_exists($byRemoteConnectorName)){
            $classConnectorName = $byRemoteConnectorName;
        }

        if (!$classConnectorName) {
            $byClassConnectorName = $prefixClassConnectorName . self::toCamelCase($object->contentClassIdentifier()) . $baseClassConnectorName;
            if (class_exists($byClassConnectorName)) {
                $classConnectorName = $byClassConnectorName;
            }
        }

        if (!$classConnectorName || !class_exists($classConnectorName)){
            return LockEditConnectorFactory::load($object, $helper, $locale);
        }

        $class = $classConnectorName::getContentClass();

        /** @var ClassConnectorInterface $classConnector */
        $classConnector = ClassConnectorFactory::instance($classConnectorName, $class, $helper);

        $data = (array)Content::createFromEzContentObject($object);
        if (isset($data['data'][$locale])){
            $classConnector->setContent($data['data'][$locale]);
        }else{
            foreach ($data['data'] as $language => $datum) {
                $classConnector->setContent($datum);
                break;
            }
        }

        if ($classConnector instanceof LockEditClassConnector){
            $classConnector->setInstallerDataDir(OpenPAINI::variable('InstanceSettings', 'InstallerDirectory', '../vendor/opencity-labs/opencity-asl-installer'));
            $classConnector->setOriginalObject($object);
        }

        return $classConnector;
    }

    /**
     * Translates a string with underscores into camel case (e.g. first_name -&gt; firstName)
     * @param string $str String in underscore format
     * @param bool $capitaliseFirstChar If true, capitalise the first char in $str
     * @return   string                              $str translated into camel caps
     */
    private static function toCamelCase($str, $capitaliseFirstChar = true)
    {
        $str = eZCharTransform::instance()->transformByGroup($str, 'identifier');
        if ($capitaliseFirstChar) {
            $str[0] = strtoupper($str[0]);
        }

        return preg_replace_callback('/_([a-z])/', function ($c) {
            return strtoupper($c[1]);
        }, $str
        );
    }
}