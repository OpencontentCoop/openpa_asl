{if or(
    and(is_set($module_result.content_info.persistent_variable.show_valuation),$module_result.content_info.persistent_variable.show_valuation),
    openpacontext().is_search_page
)}
    {include uri='design:footer/valuation.tpl'}
{/if}

{def $show_footer_menu = true()}
{if $pagedata.homepage|has_attribute('hide_footer_menu')}
    {set $show_footer_menu = cond($pagedata.homepage|attribute('hide_footer_menu').data_int|eq(1), false(), true())}
{/if}
<footer class="it-footer" id="footer">
    <div class="it-footer-main">
        <div class="container">

            <div class="row">
                <div class="col-12 footer-items-wrapper logo-wrapper">
                    {if $pagedata.homepage|has_attribute('footer_logo')}
                        <div class="it-brand-wrapper">
                            <a href="{'/'|ezurl(no)}"
                               title="{ezini('SiteSettings','SiteName')}">
                                <img class="icon" style="width: auto !important;"
                                     alt="{ezini('SiteSettings','SiteName')}"
                                     src="{render_image($pagedata.homepage|attribute('footer_logo').content['header_logo'].full_path|ezroot(no,full)).src}" />
                            </a>
                        </div>
                    {else}
                        {include uri='design:logo.tpl' in_footer=true()}
                    {/if}
                    {if and( openpaini('GeneralSettings', 'ShowFooterBanner', 'disabled')|eq('enabled'), $pagedata.homepage|has_attribute('footer_banner') )}
                        {def $footer_banner = object_handler(fetch(content, object, hash( object_id, $pagedata.homepage|attribute('footer_banner').content.relation_list[0].contentobject_id)))}
                        <a href="{$footer_banner.content_link.full_link}" class="ms-md-auto"
                           title="{$footer_banner.name.contentobject_attribute.content|wash()}">
                            <img class="icon" style="width: auto !important;height: 50px"
                                 alt="{$footer_banner.name|wash()}"
                                 src="{render_image($footer_banner.image.contentobject_attribute.content['header_logo'].full_path|ezroot(no,full)).src}" />
                        </a>
                        {undef $footer_banner}
                    {/if}
                </div>
            </div>

            {if $show_footer_menu}
                {def $top_menu_tree = array()}
                {def $top_menu_node_ids = openpaini( 'TopMenu', 'NodiCustomMenu', array())}
                {if count($top_menu_node_ids)|gt(0)}
                    {foreach $top_menu_node_ids as $id}
                        {set $top_menu_tree = $top_menu_tree|append(tree_menu( hash( 'root_node_id', $id, 'scope', 'side_menu', 'hide_empty_tag', true(), 'hide_empty_tag_callback', array('OpenPABootstrapItaliaOperators', 'tagTreeHasContents'))))}
                    {/foreach}
                {/if}
                {undef $top_menu_node_ids}

                <div class="row my-md-4">
                    {foreach array('footer_menu_area_informativa', 'footer_menu_area_istituzionale', 'footer_menu_trasparenza') as $attribute_identifier}
                    {if $pagedata.homepage|has_attribute($attribute_identifier)}
                    <div class="col-md-4 footer-items-wrapper">
                        <h3 class="footer-heading-title border-0 pb-0">
                            {$pagedata.homepage|attribute($attribute_identifier).contentclass_attribute_name|wash()}
                        </h3>
                        <ul class="footer-list">
                            {foreach $pagedata.homepage|attribute($attribute_identifier).content.relation_list as $relation_item}
                                {def $related_node = fetch(content, node, hash(node_id, $relation_item.node_id))}
                                <li><a href="{$related_node.url_alias|ezurl(no)}" title="{'Go to page'|i18n('bootstrapitalia')}: {$related_node.name|wash()}">{$related_node.name|wash()}</a></li>
                                {undef $related_node}
                            {/foreach}
                        </ul>
                    </div>
                    {/if}
                    {/foreach}
                </div>
                <hr class="separator" />
                <div class="row">
                    <div class="col-md-8 my-md-4 footer-items-wrapper">
                        <h3 class="footer-heading-title border-0">{'Contacts'|i18n('openpa/footer')}</h3>
                        <div class="row">
                            <div class="col-md-4">
                                <ul class="contact-list p-0 footer-info">
                                {if is_set($pagedata.contacts.indirizzo)}
                                    <li style="display: flex;align-items: center;">
                                        {display_icon('it-pa', 'svg', 'icon icon-sm icon-white', 'Address')}
                                        <small class="ms-2" style="word-wrap: anywhere;user-select: all;">{$pagedata.contacts.indirizzo|wash()}</small>
                                    </li>
                                {/if}
                                {if is_set($pagedata.contacts.telefono)}
                                <li>
                                    {def $tel = strReplace($pagedata.contacts.telefono,array(" ",""))}
                                    <a style="display: flex;align-items: center;" class="text-decoration-none" href="tel:{$tel}">
                                        {display_icon('it-telephone', 'svg', 'icon icon-sm icon-white', 'Phone')}
                                        <small class="ms-2" style="word-wrap: anywhere;user-select: all;">{$pagedata.contacts.telefono}</small>
                                    </a>
                                </li>
                                {/if}
                                {if is_set($pagedata.contacts.fax)}
                                    <li>
                                        {def $fax = strReplace($pagedata.contacts.fax,array(" ",""))}
                                        <a style="display: flex;align-items: center;" class="text-decoration-none" href="tel:{$fax}">
                                            {display_icon('it-file', 'svg', 'icon icon-sm icon-white', 'Fax')}
                                            <small class="ms-2" style="word-wrap: anywhere;user-select: all;">{$pagedata.contacts.fax}</small>
                                        </a>
                                    </li>
                                {/if}
                                {if is_set($pagedata.contacts.email)}
                                    <li>
                                        <a style="display: flex;align-items: center;" class="text-decoration-none" href="mailto:{$pagedata.contacts.email}">
                                            {display_icon('it-mail', 'svg', 'icon icon-sm icon-white', 'Email')}
                                            <small class="ms-2" style="word-wrap: anywhere;user-select: all;">{$pagedata.contacts.email}</small>
                                        </a>
                                    </li>
                                {/if}
                                {if is_set($pagedata.contacts.pec)}
                                    <li>
                                        <a style="display: flex;align-items: center;" class="text-decoration-none" href="mailto:{$pagedata.contacts.pec}">
                                            {display_icon('it-mail', 'svg', 'icon icon-sm icon-warning', 'PEC')}
                                            <small class="ms-2" style="word-wrap: anywhere;user-select: all;">{$pagedata.contacts.pec}</small>
                                        </a>
                                    </li>
                                {/if}
                                {if is_set($pagedata.contacts.web)}
                                    {def $webs = $pagedata.contacts.web|explode_contact()}
                                    {foreach $webs as $name => $link}
                                        <li>
                                            <a style="display: flex;align-items: center;" class="text-decoration-none" href="{$link|wash()}">
                                                {display_icon('it-link', 'svg', 'icon icon-sm icon-white', 'Website')}
                                                <small class="ms-2" style="word-wrap: anywhere;user-select: all;">{$name|wash()}</small>
                                            </a>
                                        </li>
                                    {/foreach}
                                    {undef $webs}
                                {/if}
                                {if is_set($pagedata.contacts.partita_iva)}
                                    <li style="display: flex;align-items: center;">
                                        {display_icon('it-card', 'svg', 'icon icon-sm icon-white', 'P.IVA')}
                                        <small class="ms-2" style="word-wrap: anywhere;user-select: all;">P.IVA {$pagedata.contacts.partita_iva}</small>
                                    </li>
                                {/if}
                                {if is_set($pagedata.contacts.codice_fiscale)}
                                    <li style="display: flex;align-items: center;">
                                        {display_icon('it-card', 'svg', 'icon icon-sm icon-white', 'Codice fiscale')}
                                        <small class="ms-2" style="word-wrap: anywhere;user-select: all;">C.F. {$pagedata.contacts.codice_fiscale}</small>
                                    </li>
                                {/if}
                                {if is_set($pagedata.contacts.codice_sdi)}
                                    <li>
                                        {display_icon('it-card', 'svg', 'icon icon-sm icon-white', 'SDI')}
                                        <small class="ms-2" style="word-wrap: anywhere;user-select: all;">SDI {$pagedata.contacts.codice_sdi}</small>
                                    </li>
                                {/if}
                                </ul>
                            </div>
                        </div>
                    </div>
                    {include uri='design:footer/social.tpl'}
                </div>
            {/if}
        </div>
        <hr class="separator" />
        <div class="container">
            <div class="row">
                <div class="col-12 footer-items-wrapper">
                    <div class="footer-bottom border-0 mt-0 pt-0 pb-3">

                        {def $faq_system = fetch(content, object, hash(remote_id, 'faq_system'))}
                        {if $faq_system}
                            <a data-element="faq" class="ms-0 me-4" href="{object_handler($faq_system).content_link.full_link}">{'Read the FAQ'|i18n('bootstrapitalia')}</a>
                        {/if}
                        {undef $faq_system}

                        {def $footer_links = fetch( 'openpa', 'footer_links' )}
                        {foreach $footer_links as $item}
                            {node_view_gui content_node=$item view=text_linked a_class='ms-0 me-4'}
                        {/foreach}
                        {undef $footer_links}

                        {def $needCookieConsent = cond(or(
                                and( openpaini('Seo', 'GoogleAnalyticsAccountID'), openpaini('Seo', 'GoogleCookieless')|eq('disabled') ),
                                and( openpaini('Seo', 'webAnalyticsItaliaID'), openpaini('Seo', 'WebAnalyticsItaliaCookieless')|eq('disabled') ),
                                openpaini('Seo', 'CookieConsentMultimedia')|eq('enabled')
                            ), true(), false())}
                        {if and(openpaini('CookiesSettings', 'Consent', 'advanced')|eq('advanced'), $needCookieConsent)}
                            <a href="#" class="ms-0 me-4 ccb__edit">{'Cookie settings'|i18n('bootstrapitalia/cookieconsent')}</a>
                        {/if}

                        {undef $needCookieConsent}
                        {*<a href="#">Media policy</a> @todo*}
                        <a class="ms-0 me-4" href={"/content/view/sitemap/2/"|ezurl}>{"Sitemap"|i18n("design/standard/layout")}</a>
{*                        <a href={"/openapi/doc/"|ezurl}>API</a>*}
                    </div>
                </div>
            </div>
        </div>
    </div>
</footer>
{include uri='design:footer/copyright.tpl'}
