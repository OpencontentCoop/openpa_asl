<?php

class EventOrganizationValidator extends AbstractBootstrapItaliaInputValidator
{
    const MULTIFIELD_ERROR_MESSAGE = "Popolare almeno un campo tra '%s' e '%s'";

    public function validate(): array
    {
        if ($this->class->attribute('identifier') == 'event') {
            $organizer = false;
            $organizerAsText = false;

            $organizerName = 'organizer';
            $organizerAsTextName = 'organizer_text';
            $countExisting = 0;

            foreach ($this->contentObjectAttributes as $contentObjectAttribute) {
                $contentClassAttribute = $contentObjectAttribute->contentClassAttribute();
                if ($contentClassAttribute->attribute('identifier') == 'organizer') {
                    $countExisting++;
                    $organizer = $this->hasRelations($contentObjectAttribute);
                    $organizerName = $contentClassAttribute->attribute('name');
                } elseif ($contentClassAttribute->attribute('identifier') == 'organizer_text') {
                    $countExisting++;
                    $organizerAsText = $this->hasText($contentObjectAttribute);
                    $organizerAsTextName = $contentClassAttribute->attribute('name');
                }
            }
            if ($countExisting === 2 && !$organizer && !$organizerAsText) {
                return [
                    'identifier' => 'organizer',
                    'text' => sprintf(
                        self::MULTIFIELD_ERROR_MESSAGE,
                        $organizerName,
                        $organizerAsTextName
                    ),
                ];
            }
        }

        return [];
    }
}