<?php


class OpenPABlockHandlerTags extends OpenPABlockHandler
{
    protected function run()
    {
        $tagList = $this->getTags($this->currentCustomAttributes['tags'] ?? []);
        $rootNodeId = $this->currentCustomAttributes['node_id'] ?? eZINI::instance('content.ini')->variable('NodeSettings', 'RootNode');
        $rootNode = eZContentObjectTreeNode::fetch((int)$rootNodeId);
        $this->data['root_node'] = $rootNode;
        $this->data['has_content'] = count($tagList) > 0;
        $this->data['content'] = $tagList;
    }

    protected function getTags($value)
    {
        $tagList = [];
        if (!empty($value)){
            $tagUrls = explode(',', $value);
            foreach ($tagUrls as $tagUrl) {
                if (is_numeric($tagUrl)){
                    $tag = eZTagsObject::fetch((int)$tagUrl);
                }else {
                    $tag = eZTagsObject::fetchByUrl($tagUrl);
                }
                if ($tag instanceof eZTagsObject){
                    $tagList[] = $tag;
                }
            }
        }

        return $tagList;
    }
}
