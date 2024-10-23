<?php

class BandoRankingValidator extends AbstractBootstrapItaliaInputValidator
{
    public function validate(): array
    {
        if ($this->class->attribute('identifier') == 'bando_concorso') {
            $ranking = false;
            $rankingInfo = false;
            $rankingLink = false;

            $rankingName = 'ranking';
            $rankingInfoName = 'ranking_info';
            $rankingLinkName = 'ranking_link';
            $countExisting = 0;

            foreach ($this->contentObjectAttributes as $contentObjectAttribute) {
                $contentClassAttribute = $contentObjectAttribute->contentClassAttribute();
                if ($contentClassAttribute->attribute('identifier') == 'ranking') {
                    $countExisting++;
                    $ranking = $this->hasMultiBinary($contentClassAttribute, $contentObjectAttribute);
                    $rankingName = $contentClassAttribute->attribute('name');
                } elseif ($contentClassAttribute->attribute('identifier') == 'ranking_info') {
                    $countExisting++;
                    $rankingInfo = $this->hasText($contentObjectAttribute);
                    $rankingInfoName = $contentClassAttribute->attribute('name');
                } elseif ($contentClassAttribute->attribute('identifier') == 'ranking_link') {
                    $countExisting++;
                    $rankingLink = $this->hasUrl($contentObjectAttribute);
                    $rankingLinkName = $contentClassAttribute->attribute('name');
                }
            }
            if ($countExisting === 3 && !$ranking && !$rankingInfo && !$rankingLink) {
                return [
                    'identifier' => 'ranking_info',
                    'text' => sprintf(
                        AbstractBootstrapItaliaInputValidator::MULTIFIELD_ERROR_MESSAGE,
                        $rankingName,
                        $rankingInfoName,
                        $rankingLinkName
                    ),
                ];
            }
        }

        return [];
    }
}