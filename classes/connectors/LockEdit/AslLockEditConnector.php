<?php

class AslLockEditConnector extends LockEditConnector
{
    protected function load()
    {
        if (!self::$isLoaded) {
            $this->language = \eZLocale::currentLocaleCode();
            $this->getHelper()->setSetting('language', $this->language);

            if (!$this->hasParameter('object')) {
                throw new Exception("Content not found");
            }

            $this->object = eZContentObject::fetch((int)$this->getParameter('object'));
            if ($this->object instanceof eZContentObject) {
                $parents = $this->object->assignedNodes(false);
                $parentsIdList = array_column($parents, 'parent_node_id');
                $this->getHelper()->setParameter('parent', $parentsIdList);
            }

            if ($this->object instanceof eZContentObject) {
                if (!$this->object->canRead()) {
                    throw new Exception("User can not read object #" . $this->object->attribute('id'));
                }
                if (!self::canLockEdit($this->object)) {
                    throw new \Exception("User can not edit object #" . $this->object->attribute('id'));
                }
            }

            $this->classConnector = AslLockEditConnectorFactory::load($this->object, $this->getHelper(), $this->language);

//            eZINI::instance('ezflow.ini')->setVariable('eZFlowOperations', 'UpdateOnPublish', 'disabled');

            self::$isLoaded = true;
        }
    }

}