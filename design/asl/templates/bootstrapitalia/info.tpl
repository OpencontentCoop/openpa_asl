{ezpagedata_set( 'has_container', true() )}
{def $pagedata = openpapagedata()}

<div class="container mb-3">
    <h2 class="mb-4">Gestioni contatti e informazioni generali</h2>

    {if is_set($message)}
        <div class="message-error">
            <p>{$message}</p>
        </div>
    {/if}

    <div id="info" class="border rounded p-3" style="min-height:300px"></div>
    {literal}
        <script>
          $(document).ready(function () {
            let load = function (){
              $('#info').opendataForm({}, {
                connector: 'info',
                onSuccess: function () {
                  load();
                }
              });
            }
            load();
          });
        </script>
    {/literal}

    {if $has_access_to_hot_zone}
    <form method="post" action="{'bootstrapitalia/info'|ezurl(no)}" enctype="multipart/form-data" class="form">
        <div class="border border-light bg-danger rounded p-3 my-5">
            <h4 class="text-white mb-4">Impostazioni avanzate</h4>
            <div class="row">
                <form method="post" action="{'bootstrapitalia/info'|ezurl(no)}" class="form">
                    <fieldset>
                        <legend class="text-white h5 px-0">Importa informazioni</legend>
                        <div class="form-group">
                            <label for="ImportFrom" class="text-white p-0">Importa contatti e informazioni generali da un'altra istanza OpenCity</label>
                            <div class="input-group">
                                <input type="text" class="form-control" id="ImportFrom" name="ImportFrom"
                                       placeholder="https://www.comune.bugliano.pi.it" />
                                <div class="input-group-append">
                                    <button class="btn btn-primary" type="submit">Importa</button>
                                </div>
                            </div>
                            <small class="form-text text-white">
                                Inserisci l'indirizzo di un'altra istanza OpenCity da cui importare le informazioni. Ad esempio: https://www.comune.bugliano.pi.it
                            </small>
                        </div>
                    </fieldset>
                </form>
            </div>

            {*if $bridge_connection}
            <div class="row">
                <form method="post" action="{'bootstrapitalia/info'|ezurl(no)}" class="form">
                <div class="form-group">
                    <label for="UpdateBridgeTargetUser" class="text-white p-0">Aggiorna contatti e informazioni generali nell'area personale collegata {$bridge_connection|wash()}</label>
                    <div class="input-group">
                        <input type="text" class="form-control border-right" id="UpdateBridgeTargetUser" name="UpdateBridgeTargetUser" placeholder="Inserisci il nome utente" />
                        <div class="input-group-append" style="flex: 1 1 auto;">
                            <input type="text" class="form-control" id="UpdateBridgeTargetPassword" name="UpdateBridgeTargetPassword" placeholder="e la password dell'istanza collegata" />
                        </div>
                        <div class="input-group-append">
                            <button class="btn btn-primary" type="submit">Aggiorna</button>
                        </div>
                    </div>
                </div>
                </form>
            </div>
            {/if*}

            {if count($partners)}
                <div class="row">
                    <form method="post" action="{'bootstrapitalia/info'|ezurl(no)}" class="form">
                        <fieldset>
                            <legend class="text-white h5 px-0">Partner/distributore</legend>
                            <div class="form-group">
                                <label for="SelectPartner" class="text-white p-0">Imposta partner/distributore</label>
                                <div class="input-group">
                                    <select class="form-control" id="SelectPartner" name="SelectPartner">
                                        <option></option>
                                        {foreach $partners as $partner}
                                            <option value="{$partner.identifier|wash()}"{if and($current_partner, $current_partner.identifier|eq($partner.identifier))} selected="selected"{/if}>{$partner.name|wash()} - {$partner.url|wash()}</option>
                                        {/foreach}
                                    </select>
                                    <div class="input-group-append">
                                        <button class="btn btn-primary" type="submit">Seleziona</button>
                                    </div>
                                </div>
                                <small class="form-text text-white">
                                    Il nome e l'url compaiono nel footer della pagina
                                </small>
                            </div>
                        </fieldset>
                    </form>
                </div>
            {/if}

            <div class="row">
                <form method="post" action="{'bootstrapitalia/info'|ezurl(no)}" class="form">
                    <fieldset>
                        <legend class="text-white h5 px-0">Performance interfaccia di redazione</legend>
                        <div class="form-group">
                            <label for="UpdateBridgeTargetUser" class="text-white p-0">Monitoraggio performance redazione</label>
                            <small class="form-text text-white">Inserisci il valore di `src` del <a class="text-white" href="https://docs.sentry.io/platforms/javascript/install/loader/">Sentry JavaScript Loader</a></small>
                            <div class="input-group">
                                <input type="text" class="form-control border-right" id="EditorPerformanceMonitor" name="EditorPerformanceMonitor" placeholder="https://js.sentry-cdn.com/xyz...min.js" value="{$sentry_script_loader_url}"/>
                                <div class="input-group-append">
                                    <button class="btn btn-primary" type="submit">Aggiorna</button>
                                </div>
                            </div>
                        </div>
                    </fieldset>
                </form>
            </div>

            {if has_bridge_connection()}
                <form method="post" action="{'bootstrapitalia/info'|ezurl(no)}" class="form">
                    <fieldset>
                        <legend class="text-white h5 px-0">Area personale</legend>
                        <input type="hidden" name="StanzadelcittadinoBridge" value="1" />
                        <div class="form-group form-check m-0 ps-1 pt-1 bg-white">
                            <input id="RuntimeServiceStatusCheck"
                                   class="form-check-input"
                                   type="checkbox"
                                   name="RuntimeServiceStatusCheck" {$sdc_status_check|choose( '', 'checked="checked"' )}
                                   value="" />
                            <label class="form-check-label mb-0" for="RuntimeServiceStatusCheck">
                                Mostra/nasconde i canali di erogazione nelle schede di servizio in base allo stato del servizio corrispondente in area personale
                            </label>
                        </div>
                        <div class="text-right mt-1">
                            <button class="btn btn-primary" type="submit">Aggiorna</button>
                        </div>
                    </fieldset>
                </form>
            {/if}

            <div class="row">
                <form method="post" action="{'bootstrapitalia/info'|ezurl(no)}" class="form">
                    <fieldset>
                        <legend class="text-white h5 px-0">OpenAgenda</legend>
                        <input type="hidden" name="OpenAgendaBridge" value="1">
                        <div class="form-group mb-0">
                            <label for="OpenAgendaUrl" class="text-white p-0">URL OpenAgenda</label>
                            <input type="text" class="form-control border-right" id="OpenAgendaUrl" name="OpenAgendaUrl" placeholder="https://openagenda.opencontent.it" value="{$openagenda_url}"/>
                        </div>
                        <div class="form-group form-check m-0 ps-1 bg-white">
                            <input id="OpenAgendaMainCalendar"
                                   class="form-check-input"
                                   type="checkbox"
                                   name="OpenAgendaMainCalendar" {$openagenda_embed_main|choose( '', 'checked="checked"' )}
                                   value="" />
                            <label class="form-check-label mb-0" for="OpenAgendaMainCalendar">
                                Visualizza i prossimi eventi di OpenAgenda in /Vivere-il-comune/Eventi
                            </label>
                        </div>
                        <div class="form-group form-check m-0 ps-1 bg-white">
                            <input id="OpenAgendaTopicCalendar"
                                   class="form-check-input"
                                   type="checkbox"
                                   name="OpenAgendaTopicCalendar" {$openagenda_embed_topic|choose( '', 'checked="checked"' )}
                                   value="" />
                            <label class="form-check-label mb-0" for="OpenAgendaTopicCalendar">
                                Visualizza i prossimi eventi di OpenAgenda nelle pagine argomento
                            </label>
                        </div>
                        <div class="form-group form-check m-0 ps-1 bg-white">
                            <input id="OpenAgendaOrganization"
                                   class="form-check-input"
                                   type="checkbox"
                                   name="OpenAgendaOrganization" {$openagenda_embed_organization|choose( '', 'checked="checked"' )}
                                   value="" />
                            <label class="form-check-label mb-0" for="OpenAgendaOrganization">
                                Visualizza le associazioni in /Amministrazione/Enti-e-fondazioni
                            </label>
                        </div>
                        <div class="form-group form-check m-0 ps-1 bg-white">
                            <input id="OpenAgendaPushPlace"
                                   class="form-check-input"
                                   type="checkbox"
                                   name="OpenAgendaPushPlace" {$openagenda_push_place|choose( '', 'checked="checked"' )}
                                   value="" />
                            <label class="form-check-label mb-0" for="OpenAgendaPushPlace">
                                Abilita il bottone di invio dei luoghi in OpenAgenda
                            </label>
                        </div>
                        {*<div class="form-group form-check m-0 ps-1 bg-white">
                            <input id="OpenAgendaPlaceCalendar"
                                   class="form-check-input"
                                   type="checkbox"
                                   name="OpenAgendaPlaceCalendar" {$openagenda_embed_place|choose( '', 'checked="checked"' )}
                                   value="" />
                            <label class="form-check-label mb-0" for="OpenAgendaPlaceCalendar">
                                Visualizza i prossimi eventi di OpenAgenda nelle pagine luogo
                            </label>
                        </div>*}
                        <div class="text-right mt-1">
                            <button class="btn btn-primary" type="submit">Aggiorna</button>
                        </div>
                    </fieldset>
                </form>
            </div>

            <div class="row">
                <form method="post" action="{'bootstrapitalia/info'|ezurl(no)}" class="form">
                    <fieldset>
                        <legend class="text-white h5 px-0">Calendari e prenotazione appuntamenti</legend>
                        <input type="hidden" name="StanzaDelCittadinoBooking" value="1">
                        <div class="form-group form-check m-0 ps-1 bg-white">
                            <input id="StanzaDelCittadinoBookingEnable"
                                   class="form-check-input"
                                   type="checkbox"
                                   name="StanzaDelCittadinoBookingEnable" {$stanzadelcittadino_booking|choose( '', 'checked="checked"' )}
                                   value="" />
                            <label class="form-check-label mb-0" for="StanzaDelCittadinoBookingEnable">
                                Abilita la configurazione dei calendari e il relativo widget di prenotazione
                            </label>
                        </div>
                        <div class="form-group form-check m-0 ps-1 bg-white">
                            <input id="StanzaDelCittadinoBookingStoreAsApplication"
                                   class="form-check-input"
                                   type="checkbox"
                                   name="StanzaDelCittadinoBookingStoreAsApplication" {$stanzadelcittadino_booking_store_as_application|choose( '', 'checked="checked"' )}
                                   value="" />
                            <label class="form-check-label mb-0" for="StanzaDelCittadinoBookingStoreAsApplication">
                                Salva in area personale gli appuntamenti come pratiche (applications)
                            </label>
                        </div>
                        <div class="form-group form-check m-0 ps-1 bg-white">
                            <input id="StanzaDelCittadinoBookingServiceDiscover"
                                   class="form-check-input"
                                   type="checkbox"
                                   name="StanzaDelCittadinoBookingServiceDiscover" {$stanzadelcittadino_booking_service_discover|choose( '', 'checked="checked"' )}
                                   value="" />
                            <label class="form-check-label mb-0" for="StanzaDelCittadinoBookingServiceDiscover">
                                Visualizza il selettore dei servizi invece che il widget di appuntamento generico
                            </label>
                        </div>
                        <div class="text-right mt-1">
                            <button class="btn btn-primary" type="submit">Aggiorna</button>
                        </div>
                    </fieldset>
                </form>
            </div>

            <div class="row">
                <form method="post" action="{'bootstrapitalia/info'|ezurl(no)}" class="form">
                    <fieldset>
                        <legend class="text-white h5 px-0">Integrazione con area personale (servizi builtin)</legend>
                        {foreach $built_in_options as $built_in_option}
                            {if $built_in_option.type|eq('boolean')}
                                <p class="text-white font-weight-bold mt-2 mb-1">{$built_in_option.name|wash()}</p>
                                <div class="form-group form-check m-0 ps-1 bg-white">
                                    <input id="StanzaDelCittadinoBuiltin_{$built_in_option.identifier|wash()}"
                                           class="form-check-input"
                                           type="checkbox"
                                           name="StanzaDelCittadinoBuiltin[{$built_in_option.identifier|wash()}]" {$built_in_option.current_value|choose( '', 'checked="checked"' )}
                                           value="1" />
                                    <label class="form-check-label mb-0" for="StanzaDelCittadinoBuiltin_{$built_in_option.identifier|wash()}">
                                        {$built_in_option.name|wash()}
                                    </label>
                                </div>
                            {else}
                                <div class="form-group mb-0">
                                    <label for="StanzaDelCittadinoBuiltin_{$built_in_option.identifier|wash()}" class="text-white p-0">{$built_in_option.name|wash()}</label>
                                    <input type="text" class="form-control border-right"
                                           placeholder="{$built_in_option.placeholder|wash()}"
                                           id="StanzaDelCittadinoBuiltin_{$built_in_option.identifier|wash()}"
                                           name="StanzaDelCittadinoBuiltin[{$built_in_option.identifier|wash()}]"
                                           value="{$built_in_option.current_value|wash()}"/>
                                </div>
                            {/if}
                        {/foreach}
                        <div class="text-right mt-1">
                            <button class="btn btn-primary" type="submit">Aggiorna</button>
                        </div>
                    </fieldset>
                </form>
            </div>

            <div class="row">
                <form method="post" action="{'bootstrapitalia/info'|ezurl(no)}" class="form">
                    <fieldset>
                        <legend class="text-white h5 px-0">Pagina di accesso all'area personale</legend>
                        <input type="hidden" name="AccessPageSettings" value="1">
                        <div class="form-group form-check m-0 ps-1 bg-white">
                            <input id="AccessPageSettingsSpidEnable"
                                   class="form-check-input"
                                   type="checkbox"
                                   name="AccessPageSettingsSpidEnable" {$access_spid|choose( '', 'checked="checked"' )}
                                   disabled="disabled"
                                   value="" />
                            <label class="form-check-label mb-0" for="AccessPageSettingsSpidEnable">
                                Abilita SPID
                            </label>
                        </div>
                        <div class="form-group form-check m-0 ps-1 bg-white">
                            <input id="AccessPageSettingsCieEnable"
                                   class="form-check-input"
                                   type="checkbox"
                                   name="AccessPageSettingsCieEnable" {$access_cie|choose( '', 'checked="checked"' )}
                                   value="" />
                            <label class="form-check-label mb-0" for="AccessPageSettingsCieEnable">
                                Abilita CIE
                            </label>
                        </div>
                        <div class="form-group form-check m-0 ps-1 bg-white">
                            <input id="AccessPageSettingsEidasEnable"
                                   class="form-check-input"
                                   type="checkbox"
                                   name="AccessPageSettingsEidasEnable" {$access_eidas|choose( '', 'checked="checked"' )}
                                   value="" />
                            <label class="form-check-label mb-0" for="AccessPageSettingsEidasEnable">
                                Abilita eIDAS
                            </label>
                        </div>
                        <div class="text-right mt-1">
                            <button class="btn btn-primary" type="submit">Aggiorna</button>
                        </div>
                    </fieldset>
                </form>
            </div>

            <form method="post" action="{'bootstrapitalia/info'|ezurl(no)}" class="form">
                <fieldset>
                    <legend class="text-white h5 px-0">Sistema di approvazione dei contenuti</legend>
                    <input type="hidden" name="Moderation" value="1" />
                    <div class="form-group form-check m-0 ps-1 pt-1 bg-white">
                        <input id="ModerationIsEnabled"
                               class="form-check-input"
                               type="checkbox"
                               name="ModerationIsEnabled" {is_approval_enabled()|choose( '', 'checked="checked"' )}
                               value="" />
                        <label class="form-check-label mb-0" for="ModerationIsEnabled">
                            Abilita il sistema di approvazione dei contenuti basato sulle versioni
                        </label>
                    </div>
                    <div class="text-right mt-1">
                        <button class="btn btn-primary" type="submit">Aggiorna</button>
                    </div>
                </fieldset>
            </form>

        </div>
    </form>
    {/if}

</div>
{include uri='design:load_ocopendata_forms.tpl'}