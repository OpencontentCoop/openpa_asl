<?php

use Opencontent\Ocopendata\Forms\Connectors\OpendataConnector\FieldConnector;

class AslHomepageLockEditClassConnector extends LockEditClassConnector
{
    protected $sourceBlocks = [
        [
            "block_id" => "home-search",
            "name" => "Cerca nel sito",
            "type" => "Ricerca",
            "view" => "default",
            "custom_attributes" => [
                "color_style" => "",
                "container_style" => "",
            ],
            "valid_items" => [
            ],
        ],
        [
            "block_id" => "home-monitoring",
            "name" => "",
            "type" => "HTML",
            "view" => "html",
            "custom_attributes" => [
                "color_style" => "",
                "container_style" => "",
                "api" => "",
                "html" => "",
            ],
            "valid_items" => [
            ],
        ],
        [
            "block_id" => "home-news",
            "name" => "In evidenza",
            "type" => "ListaManuale",
            "view" => "lista_banner",
            "custom_attributes" => [
                "elementi_per_riga" => "auto",
                "color_style" => "",
                "container_style" => "",
                "show_all_link" => "1",
                "show_all_text" => "Tutte le novità",
                "intro_text" => "",
            ],
            "valid_items" => [
            ],
        ],
        [
            "block_id" => "home-service",
            "name" => "Servizi e prestazioni",
            "type" => "Tags",
            "view" => "default",
            "custom_attributes" => [
                "tags" => "",
                "color_style" => "bg-100",
                "container_style" => "",
                "show_all_link" => "1",
                "show_all_text" => "Tutti i servizi",
                "intro_text" => "Scopri e accedi ai servizi dell'Azienda come ad esempio visite specialistiche, esami, percorsi di cura, referti e certificati",
                "node_id" => "",
            ],
            "valid_items" => [
            ],
        ],
        [
            "block_id" => "home-fse",
            "name" => "",
            "type" => "Singolo",
            "view" => "evidence",
            "custom_attributes" => [
                "color_style" => "",
                "container_style" => "",
                "intro_text" => "",
                "show_all_link" => "1",
                "show_all_text" => "Vai al servizio",
            ],
            "valid_items" => [
            ],
        ],
        [
            "block_id" => "home-howto",
            "name" => "Come fare per",
            "type" => "ListaManuale",
            "view" => "lista_card_teaser",
            "custom_attributes" => [
                "limite" => "6",
                "elementi_per_riga" => "2",
                "color_style" => "bg-100",
                "container_style" => "",
                "show_all_link" => "1",
                "show_all_text" => "Tutti i come fare per",
                "intro_text" => "Scopri e approfondisci tutte le procedure offerte",
            ],
            "valid_items" => [
            ],
        ],
        [
            "block_id" => "home-usertype",
            "name" => "Tutto per",
            "type" => "ListaManuale",
            "view" => "lista_card_teaser",
            "custom_attributes" => [
                "elementi_per_riga" => "4",
                "color_style" => "",
                "container_style" => "",
                "show_all_link" => "",
                "show_all_text" => "",
                "intro_text" => "Scopri i servizi, le strutture e le novità per tipologia di utente",
            ],
            "valid_items" => [
            ],
        ],
        [
            "block_id" => "home-communications",
            "name" => "Comunicazioni",
            "type" => "ListaAutomatica",
            "view" => "lista_card",
            "custom_attributes" => [
                "limite" => "3",
                "elementi_per_riga" => "3",
                "includi_classi" => "article,event",
                "escludi_classi" => "",
                "ordinamento" => "pubblicato",
                "livello_profondita" => "",
                "state_id" => "",
                "topic_node_id" => "",
                "tags" => "",
                "color_style" => "bg-100",
                "container_style" => "",
                "show_all_link" => "1",
                "show_all_text" => "Tutte le novità",
                "intro_text" => "Esplora tutte le notizie, i comunicati stampa e gli eventi",
                "node_id" => "",
            ],
            "valid_items" => [
            ],
        ],
        [
            "block_id" => "home-announcements",
            "name" => "Bandi e concorsi",
            "type" => "ListaPaginata",
            "view" => "lista_paginata_card",
            "custom_attributes" => [
                "limite" => "4",
                "elementi_per_riga" => "2",
                "includi_classi" => "bando_concorso",
                "ordinamento" => "pubblicato",
                "state_id" => "",
                "topic_node_id" => "",
                "tags" => "",
                "color_style" => "",
                "container_style" => "",
                "show_all_link" => "",
                "show_all_text" => "",
                "intro_text" => "Scopri tutti i bandi e concorsi attivi",
            ],
            "valid_items" => [
            ],
        ],
    ];

    private $hiddenFields = [
        'section_search_title',
    ];

    protected function fetchSourcePathInfo(): array
    {
        return [];
    }

    public function getData()
    {
        $this->currentBlocks = $this->content['page']['content']['global']['blocks'];
        $serviceTags = [];
        $categories = explode(',', $this->findBlockById('home-service')['custom_attributes']['tags']);
        foreach ($categories as $category) {
            $tag = eZTagsObject::fetchByUrl($category);
            if ($tag instanceof eZTagsObject){
                $serviceTags[] = [
                    'id' => (int)$tag->attribute('id'),
                    'name' => $tag->attribute('keyword'),
                ];
            }
        }
        $serviceTags = array_column($serviceTags, 'name');

        return [
            'section_search_title' => $this->findBlockById('home-search')['name']
                ?? $this->findBlockById('home-search', true)['name'],
            'section_search_items' => $this->mapListaManualeToRelations('home-search') ?? [],
            'section_search_terms' => $this->decodeTerms(
                (string)$this->findBlockById('home-search')['custom_attributes']['search_terms']
            ),

            'section_news_title' =>
                $this->findBlockById('home-news')['name']
                ?? $this->findBlockById('home-news', true)['name'],
            'section_news_intro' =>
                $this->findBlockById('home-news')['custom_attributes']['intro_text'] ??
                $this->findBlockById('home-news', true)['custom_attributes']['intro_text'],
            'section_news_items' => $this->mapListaManualeToRelations('home-news') ?? [],

            'section_service_title' =>
                $this->findBlockById('home-service')['name']
                ?? $this->findBlockById('home-service', true)['name'],
            'section_service_intro' =>
                $this->findBlockById('home-service')['custom_attributes']['intro_text'] ??
                $this->findBlockById('home-service', true)['custom_attributes']['intro_text'],
            'section_service_items' => $serviceTags,

            'section_fse_item' => $this->mapListaManualeToRelations('home-fse') ?? [],

            'section_howto_title' =>
                $this->findBlockById('home-howto')['name'] ??
                $this->findBlockById('home-howto', true)['name'],
            'section_howto_intro' =>
                $this->findBlockById('home-howto')['custom_attributes']['intro_text'] ??
                $this->findBlockById('home-howto', true)['custom_attributes']['intro_text'],
            'section_howto_items' => $this->mapListaManualeToRelations('home-howto') ?? [],

            'section_usertype_title' =>
                $this->findBlockById('home-usertype')['name'] ??
                $this->findBlockById('home-usertype', true)['name'],
            'section_usertype_intro' =>
                $this->findBlockById('home-usertype')['custom_attributes']['intro_text'] ??
                $this->findBlockById('home-usertype', true)['custom_attributes']['intro_text'],
            'section_usertype_items' => $this->mapListaManualeToRelations('home-usertype') ?? [],

            'section_communications_title' =>
                $this->findBlockById('home-communications')['name'] ??
                $this->findBlockById('home-communications', true)['name'],
            'section_communications_intro' =>
                $this->findBlockById('home-communications')['custom_attributes']['intro_text'] ??
                $this->findBlockById('home-communications', true)['custom_attributes']['intro_text'],

            'section_announcements_title' =>
                $this->findBlockById('home-announcements')['name'] ??
                $this->findBlockById('home-announcements', true)['name'],
            'section_announcements_intro' =>
                $this->findBlockById('home-announcements')['custom_attributes']['intro_text'] ??
                $this->findBlockById('home-announcements', true)['custom_attributes']['intro_text'],

            'section_monitoring_api' =>
                $this->findBlockById('home-monitoring')['custom_attributes']['api'] ??
                $this->findBlockById('home-monitoring', true)['custom_attributes']['api'],
        ];
    }

    protected function cleanSourceBlocks($blocks): ?array
    {
        return [];
    }

    public function getSchema()
    {
        $schema = parent::getSchema();

        $schema['properties']['section_search_items']['maxItems'] = 6;
        $schema['properties']['section_search_terms']['maxItems'] = 6;
        $schema['properties']['section_news_items']['maxItems'] = 3;
        $schema['properties']['section_service_items']['maxItems'] = 3;
        $schema['properties']['section_howto_items']['maxItems'] = 6;
        $schema['properties']['section_howto_items']['minItems'] = 1;
        $schema['properties']['section_usertype_items']['maxItems'] = 8;

        return $schema;
    }

    public function getOptions()
    {
        $options = parent::getOptions();

        $options['fields']['section_news_items']['browse']['classes'] = [
            'event', 'article'
        ];
        $options['fields']['section_service_items']['type'] = 'select';
        $options['fields']['section_service_items']['multiselect'] = [
            'buttonClass' => 'btn btn-primary',
            'selectAllText' => ' Seleziona tutti',
            'nSelectedText' => ' elementi selezionati',
            'nonSelectedText' => 'Nessun elemento è selezionato',
            'allSelectedText' => 'Tutti gli elementi sono selezionati',
        ];
        foreach ($this->hiddenFields as $field) {
            $options['fields'][$field]['type'] = 'hidden';
        }
        $serviceContainer = eZContentObject::fetchByRemoteID('all-services');
        if ($serviceContainer instanceof eZContentObject) {
            $options['fields']['section_fse_item']['browse']['subtree'] = $serviceContainer->mainNodeID();
        }
        $options['hideInitValidationError'] = false;
        return $options;
    }

    protected function getLayout(): array
    {
        $labels = [
            'search' => 'Motore di ricerca',
            'news' => 'Notizie in evidenza',
            'service' => 'Servizi e prestazioni',
            'fse' => 'Fascicolo Sanitario Elettronico',
            'howto' => 'Come fare per',
            'usertype' => 'Tutto per',
            'communications' => 'Comunicazioni',
            'announcements' => 'Bandi e concorsi',
            'monitoring' => 'Dashboard di monitoraggio',
        ];

        $schema = $this->getSchema();
        $categories = [];
        foreach ($schema['properties'] as $identifier => $property) {
            if (in_array($identifier, $this->hiddenFields)){
                continue;
            }
            $parts = explode('_', $identifier, 3);
            $category = $parts[1];
            if (!isset($categories[$category])) {
                $categories[$category] = [
                    'identifier' => $category,
                    'name' => $labels[$category] ?? $category,
                    'identifiers' => [],
                ];
            }
            $categories[$category]['identifiers'][] = $identifier;
        }

        $bindings = [];
        $tabs = '<div class="col-3"><ul class="nav nav-tabs nav-tabs-vertical" role="tablist" aria-orientation="vertical">';
        $panels = '<div class="col-9 tab-content">';
        $i = 0;
        foreach ($categories as $category) {
            $activeClass = $i == 0 ? 'active' : '';
            $tabs .= '<li class="nav-item"><a class="nav-link ps-0 ' . $activeClass . '" data-toggle="tab" data-bs-toggle="tab" href="#' . $category['identifier'] . '" data-focus-mouse="false">' . $category['name'] . '</a></li>';
            $panels .= '<div class="lockedit-tab position-relative clearfix attribute-edit tab-pane p-2 mt-2 ' . $activeClass . '" id="' . $category['identifier'] . '"></div>';
            foreach ($category['identifiers'] as $field) {
                $bindings[$field] = $category['identifier'];
            }
            $i++;
        }
        $tabs .= '</ul></div>';
        $panels .= '</div>';

        return [
            'template' => '<div class="container px-4 my-4"><legend class="alpaca-container-label">{{options.label}}</legend><small>{{schema.description}}</small><div class="row mt-4 mb-5">' . $tabs . $panels . '</div></div>',
            'bindings' => $bindings,
        ];
    }

    public static function getContentClass(): eZContentClass
    {
        return eZContentClass::fetchByIdentifier('edit_homepage');
    }

    protected function mapSubmitData($data): array
    {
        $blocks = [];
        foreach ($this->sourceBlocks as $block) {
            $section = str_replace('home-', '', $block['block_id']);
            if (empty($section)) {
                continue;
            }

            $sectionBase = 'section_' . $section . '_';
            $block['name'] = $data[$sectionBase . 'title'] ?? '';
            $block['custom_attributes']['intro_text'] = $data[$sectionBase . 'intro'] ?? '';

            switch ($section) {
                case 'service':
                    $tags = array_map(
                        function ($value) {
                            return 'Servizi pubblici/Categoria del servizio/' . trim($value);
                        },
                        (array)$data[$sectionBase . 'items']
                    );
                    $block['custom_attributes']['tags'] = implode(',', $tags);
                    $block['custom_attributes']['node_id'] = $this->fetchMainNodeIDByObjectRemoteID('all-services');
                    break;

                case 'communications':
                case 'announcements':
                    $block['custom_attributes']['node_id'] = $this->fetchMainNodeIDByObjectRemoteID('news');
                    break;

                case 'fse':
                    $validItems = [];
                    if (isset($data[$sectionBase . 'item'])) {
                        foreach ($data[$sectionBase . 'item'] as $item) {
                            $itemObject = eZContentObject::fetch((int)$item['id']);
                            if ($itemObject instanceof eZContentObject) {
                                $validItems[] = $itemObject->attribute('remote_id');
                            }
                        }
                    }
                    $block['valid_items'] = $validItems;
                    break;

                case 'monitoring':
                    if (isset($data[$sectionBase . 'api'])) {
                        $apiUrl = $data[$sectionBase . 'api'];
                        $widgetUrl = OpenPAINI::variable(
                            'MonitoraggioPS',
                            'ScriptSrc',
                            "https://s3.eu-west-1.amazonaws.com/static.opencityitalia.it/widgets/attesa-ps/latest/bootstrap-italia%402/js/web-formio.js"
                        );
                        $block['custom_attributes']['api'] = $apiUrl;
                        $block['custom_attributes']['html'] = '<widget-attesa-ps url="' . $apiUrl . '" city=""></widget-attesa-ps><script src="' . $widgetUrl . '"></script>';
                    }
                    break;

                default:
                    if ($section === 'search'
                        && !empty($data[$sectionBase . 'terms'])
                        && !in_array($sectionBase . 'terms', $this->hiddenFields)){
                        $block['custom_attributes']['search_terms'] = $this->encodeTerms($data[$sectionBase . 'terms']);
                    }

                    if ($section === 'usertype'){
                        $block['custom_attributes']['elementi_per_riga'] = ceil(count($data[$sectionBase . 'items'])/2);
                        if ($block['custom_attributes']['elementi_per_riga'] > 4){
                            $block['custom_attributes']['elementi_per_riga'] = 4;
                        }
                        if ($block['custom_attributes']['elementi_per_riga'] < 1){
                            $block['custom_attributes']['elementi_per_riga'] = 1;
                        }
                    }

                    $validItems = [];
                    if (isset($data[$sectionBase . 'items'])) {
                        foreach ($data[$sectionBase . 'items'] as $item) {
                            $itemObject = eZContentObject::fetch((int)$item['id']);
                            if ($itemObject instanceof eZContentObject) {
                                $validItems[] = $itemObject->attribute('remote_id');
                            }
                        }
                    }
                    $block['valid_items'] = $validItems;
            }

            $blocks[] = $block;
        }

        $page = $this->content['page']['content'];
        $page['zone_layout'] = 'desItaGlobal';
        $page['global']['blocks'] = $blocks;
        $page['global']['zone_id'] = 'homepage_page_zone_id';

        return [
            'page' => $page,
        ];
    }

    protected function mapListaManualeToRelations($block): ?array
    {
        if (is_string($block)) {
            $block = $this->findBlockById($block);
        }
        if (isset($block['valid_items'][0])
            && in_array($block['type'], ['Ricerca', 'ListaManuale', 'Singolo'])) {
            $data = [];
            foreach ($block['valid_items'] as $objectId) {
                $object = eZContentObject::fetchByRemoteID($objectId);
                if ($object instanceof eZContentObject) {
                    $data[] = [
                        'id' => $object->attribute('id'),
                        'name' => $object->attribute('name'),
                        'class' => $object->contentClassIdentifier(),
                    ];
                }
            }

            return $data;
        }

        return null;
    }

    private function encodeTerms(array $terms)
    {
        $termStrings = [];
        foreach ($terms as $term){
            $termStrings[] = implode('=>', $term);
        }
        return implode('|', $termStrings);
    }

    private function decodeTerms(string $termsString)
    {
        $terms = [];
        $termStrings = explode('|', $termsString);
        foreach ($termStrings as $termString){
            $parts = explode('=>', $termString);
            $terms[] = [
                'label' => $parts[0],
                'value' => $parts[1],
            ];
        }

        return $terms;
    }

    public function getFieldConnectors()
    {
        $this->fieldConnectors = parent::getFieldConnectors();
        $classDataMap = $this->class->dataMap();
        $this->fieldConnectors['section_service_items'] = new FieldConnector\TagsField(
            $classDataMap['section_service_items'],
            $this->class,
            $this->getHelper()
        );
        return $this->fieldConnectors;
    }


}