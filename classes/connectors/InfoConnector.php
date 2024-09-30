<?php

use Opencontent\Ocopendata\Forms\Connectors\AbstractBaseConnector;
use Opencontent\Ocopendata\Forms\Connectors\OpendataConnector\CleanableFieldConnectorInterface;
use Opencontent\Ocopendata\Forms\Connectors\OpendataConnector\FieldConnectorFactory;
use Opencontent\Ocopendata\Forms\Connectors\OpendataConnector\UploadFieldConnector;
use Opencontent\Opendata\Api\ContentRepository;
use Opencontent\Opendata\Api\EnvironmentLoader;
use Opencontent\Opendata\Api\Values\Content;
use Opencontent\Opendata\Rest\Client\PayloadBuilder;

class InfoConnector extends AbstractBaseConnector
{
    protected static $isLoaded;

    protected $language;

    /**
     * @var eZContentObject
     */
    protected $object;

    protected $contactSections = [
        [
            'label' => 'Contatti',
            'identifier' => 'general',
            'fields' => [
                'telefono' => [],
                'fax' => [],
                'numero_verde' => [],
                'email' => [],
                'pec' => [],
                'web' => [],
                'indirizzo' => [],
                'via' => [],
                'numero_civico' => [],
                'cap' => [],
                'comune' => [],
                'codice_fiscale' => [],
                'partita_iva' => [],
                'codice_sdi' => [],
                'latitudine' => [],
                'longitudine' => [],
            ],
        ],
        [
            'label' => 'Social',
            'identifier' => 'social',
            'fields' => [
                'facebook' => [],
                'twitter' => [],
                'linkedin' => [],
                'instagram' => [],
                'youtube' => [],
                'whatsapp' => [],
                'telegram' => [],
                'tiktok' => [],

            ],
        ],
        [
            'label' => 'Integrazioni',
            'identifier' => 'integrations',
            'fields' => [
                'link_area_personale' => [],
                'link_assistenza' => [],
                'link_prenotazione_appuntamento' => [],
                'link_segnalazione_disservizio' => [],
                'newsletter' => [],
            ],
        ],
    ];

    protected $attributes = [
        'logo',
        'apple_touch_icon',
        'favicon',
        'footer_logo',
        'link_nell_header',
        'footer_menu_area_informativa',
        'footer_menu_area_istituzionale',
        'footer_menu_trasparenza',
        'link_nel_footer',
        'footer_banner',
    ];

    protected $attributeConnectors = [];

    protected $data = [];

    protected function load()
    {
        if (!self::$isLoaded) {
            $this->language = \eZLocale::currentLocaleCode();
            $this->getHelper()->setSetting('language', $this->language);

            $home = OpenPaFunctionCollection::fetchHome();
            if (!$home instanceof eZContentObjectTreeNode) {
                throw new \Exception("Homepage not found");
            }

            $this->object = $home->object();
            if ($this->object instanceof eZContentObject) {
                if (!$this->object->canRead()) {
                    throw new \Exception("User can not read object #" . $this->object->attribute('id'));
                }
                if (!$this->object->canEdit() && $this->getHelper()->getParameter('view') != 'display') {
                    throw new \Exception("User can not edit object #" . $this->object->attribute('id'));
                }
            }

            $contactFields = [];
            $pagedata = new \OpenPAPageData();
            $contactsHash = $pagedata->getContactsData();
            $trans = eZCharTransform::instance();
            foreach (OpenPAAttributeContactsHandler::getContactsFields() as $label) {
                $identifier = $trans->transformByGroup($label, 'identifier');
                $contactFields[$identifier] = [
                    'label' => $label,
                    'identifier' => $identifier,
                ];
                $this->data[$identifier] = $contactsHash[$identifier] ?? '';
            }
            foreach ($this->contactSections as $index => $section) {
                foreach (array_keys($section['fields']) as $field) {
                    if (isset($contactFields[$field])) {
                        $this->contactSections[$index]['fields'][$field] = $contactFields[$field];
                    }
                }
            }

            $data = (array)Content::createFromEzContentObject($this->object);
            $locale = \eZLocale::currentLocaleCode();
            if (isset($data['data'][$locale])) {
                $content = $data['data'][$locale];
            } else {
                foreach ($data['data'] as $language => $datum) {
                    $content = $datum;
                    break;
                }
            }

            $class = $this->object->contentClass();
            $classDataMap = $class->dataMap();
            foreach ($this->attributes as $identifier) {
                if (isset($classDataMap[$identifier])) {
                    $this->attributeConnectors[$identifier] = FieldConnectorFactory::load(
                        $classDataMap[$identifier],
                        $class,
                        $this->getHelper()
                    );
                    $this->attributeConnectors[$identifier]->setContent($content[$identifier] ?? []);
                    $this->data[$identifier] = $this->attributeConnectors[$identifier]->getData();
                }
            }


            self::$isLoaded = true;
        }
    }

    public function runService($serviceIdentifier)
    {
        $this->load();
        return parent::runService($serviceIdentifier);
    }

    protected function getData()
    {
        return $this->data;
    }

    protected function getSchema()
    {
        $data = [
            'title' => '',
            "type" => "object",
            "properties" => [],
        ];

        foreach ($this->contactSections as $section) {
            foreach ($section['fields'] as $identifier => $field) {
                $data['properties'][$identifier] = [
                    "type" => "string",
                    "title" => $field['label'],
                ];
            }
        }

        foreach ($this->attributeConnectors as $identifier => $connector) {
            $data["properties"][$identifier] = $connector->getSchema();
        }


        return $data;
    }

    protected function getOptions()
    {
        $data = [
            "form" => [
                "attributes" => [
                    "class" => 'info-connector',
                    "action" => $this->getHelper()->getServiceUrl('action', $this->getHelper()->getParameters()),
                    "method" => "post",
                    "enctype" => "multipart/form-data",
                ],
            ],
        ];

        foreach ($this->attributeConnectors as $identifier => $fieldConnector) {
            $data["fields"][$identifier] = $fieldConnector->getOptions();
            if (empty($data["fields"][$identifier])) {
                unset($data["fields"][$identifier]);
            }
        }

        return $data;
    }

    public function getView()
    {
        $localeMap = [
            'eng-GB' => false,
            'chi-CN' => 'zh_CN',
            'cze-CZ' => 'cs_CZ',
            'cro-HR' => 'hr_HR',
            'dut-NL' => 'nl_BE',
            'fin-FI' => 'fi_FI',
            'fre-FR' => 'fr_FR',
            'ger-DE' => 'de_DE',
            'ell-GR' => 'el_GR',
            'ita-IT' => 'it_IT',
            'jpn-JP' => 'ja_JP',
            'nor-NO' => 'nb_NO',
            'pol-PL' => 'pl_PL',
            'por-BR' => 'pt_BR',
            'esl-ES' => 'es_ES',
            'swe-SE' => 'sv_SE',
        ];
        $currentLanguage = $this->getHelper()->getSetting('language');
        $locale = $localeMap[$currentLanguage] ?? "it_IT";

        $view = [
            "parent" => "bootstrap-edit",
            "locale" => $locale,
        ];

        $categories = [];
        foreach ($this->contactSections as $section) {
            $categories[$section['identifier']] = [
                'identifier' => $section['identifier'],
                'name' => $section['label'],
                'identifiers' => array_keys($section['fields']),
            ];
        }
        foreach ($this->attributeConnectors as $identifier => $fieldConnector) {
            $categories[$identifier] = [
                'identifier' => $identifier,
                'name' => $fieldConnector->getSchema()['title'],
                'identifiers' => [$identifier],
            ];
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

        $view['layout'] = [
            'template' => '<div class="container p-0"><legend class="alpaca-container-label">{{options.label}}</legend><small>{{schema.description}}</small><div class="row mt-4 mb-5">' . $tabs . $panels . '</div></div>',
            'bindings' => $bindings,
        ];

        return $view;
    }

    protected function submit()
    {
        $payload = $this->getPayloadFromArray($_POST);
        $contentRepository = new ContentRepository();
        $contentRepository->setEnvironment(EnvironmentLoader::loadPreset('content'));

        $result = $contentRepository->update($payload->getArrayCopy());

        foreach ($this->attributeConnectors as $connector) {
            if ($connector instanceof CleanableFieldConnectorInterface) {
                $connector->cleanup();
            }
        }
        OpenPAPageData::clearOnModifyHomepage();

        return $result;
    }

    protected function upload()
    {
        if ($this->getHelper()->hasParameter('attribute')) {
            $id = $this->getHelper()->getParameter('attribute');
            foreach ($this->attributeConnectors as $connector) {
                if ($connector->getAttribute()->attribute('id') == $id) {
                    if ($connector instanceof UploadFieldConnector) {
                        return $connector->handleUpload(
                            $this->getHelper()->getSetting('upload_param_name_prefix')
                        );
                    }
                }
            }
        }

        return false;
    }

    protected function getPayloadFromArray(array $data)
    {
        $payload = new PayloadBuilder();

        $contacts = [];
        foreach ($this->contactSections as $section) {
            foreach ($section['fields'] as $identifier => $field) {
                $contacts[] = [
                    'media' => $field['label'],
                    'value' => $data[$identifier] ?? '',
                ];
            }
        }
        $payload->setData(
            $this->getHelper()->getSetting('language'),
            'contacts',
            $contacts
        );

        $payload->setId((int)$this->object->attribute('id'));
        $payload->setClassIdentifier($this->object->attribute('class_identifier'));
        $payload->setLanguages([$this->getHelper()->getSetting('language')]);

        foreach ($this->attributeConnectors as $identifier => $connector) {
            $postData = isset($data[$identifier]) ? $data[$identifier] : null;
            if ($postData) {
                $payloadData = $connector->setPayload($postData);
                if ($payloadData !== null) {
                    $payload->setData(
                        $this->getHelper()->getSetting('language'),
                        $identifier,
                        $payloadData
                    );
                }
            }
        }

        return $payload;
    }
}