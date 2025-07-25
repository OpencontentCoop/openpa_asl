{if or(ezini_hasvariable('RegionalSettings', 'TranslationSA')|not(), and(ezini_hasvariable('RegionalSettings', 'TranslationSA'), ezini('RegionalSettings', 'TranslationSA')|count()|eq(0)))}
{def $node_languages = $node.object.languages}
{if $node_languages|count()|gt(1)}
<div>
    <div class="dropdown mb-2">
        <button class="btn btn-dropdown dropdown-toggle text-decoration-underline d-inline-flex align-items-center fs-0" type="button" id="shareActions" data-toggle="dropdown" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false" aria-label="condividi sui social">
            {display_icon('it-more-actions', 'svg', 'icon')}
            <small>{'Translations'|i18n('design/admin/class/view')}</small>
        </button>
        <div class="dropdown-menu shadow-lg" aria-labelledby="shareActions">
            <div class="link-list-wrapper">
                <ul class="link-list" role="menu">
                    {foreach $node_languages as $language}
                        {if $node.object.available_languages|contains($language.locale)}
                            {if $language.locale|ne($node.object.current_language)}
                                <li>
                                    <a role="menuitem" class="list-item text-nowrap" href="{concat( $node.url_alias, '/(language)/', $language.locale )|ezurl(no)}">
                                        <img src="{$language.locale|flag_icon}" width="18" height="12" alt="{$language.locale}" />
                                        <span>{$language.name|wash()}</span>
                                    </a>
                                </li>
                            {/if}
                        {/if}
                    {/foreach}
                </ul>
            </div>
        </div>
    </div>
</div>
{/if}
{undef $node_languages}
{/if}

<div class="dropdown">
    <button class="btn btn-dropdown dropdown-toggle text-decoration-underline d-inline-flex align-items-center fs-0" type="button" id="shareActions" data-toggle="dropdown" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false" aria-label="condividi sui social">
        {display_icon('it-share', 'svg', 'icon')}
        <small>{'Share'|i18n('bootstrapitalia')}</small>
    </button>
    <div class="dropdown-menu shadow-lg" aria-labelledby="shareActions">
        <div class="link-list-wrapper">
            <ul class="link-list" role="menu">
                <li>
                    <a role="menuitem" class="list-item text-nowrap" href="https://facebook.com/sharer/sharer.php?u={$node.url_alias|ezurl(no,full)|urlencode}" target="_blank" rel="noopener" aria-label="Share on Facebook">
                        {display_icon('it-facebook', 'svg', 'icon')}
                        <span>Facebook</span>
                    </a>
                </li>
                <li>
                    <a role="menuitem" class="list-item text-nowrap" href="https://twitter.com/intent/tweet/?text={concat($node.name, ' ', $node.url_alias|ezurl(no,full))|urlencode}" target="_blank" rel="noopener" aria-label="Share on Twitter">
                        {display_icon('it-twitter', 'svg', 'icon')}
                        <span>Twitter</span>
                    </a>
                </li>
                <li>
                    <a role="menuitem" class="list-item text-nowrap" href="http://www.linkedin.com/shareArticle?mini=true&amp;url={$node.url_alias|ezurl(no,full)|urlencode}&title={$node.name|wash()}&ro=false&source={ezini('SiteSettings','SiteURL')}">
                        {display_icon('it-linkedin', 'svg', 'icon')}
                        <span>Linkedin</span>
                    </a>
                </li>
                <li>
                    <a role="menuitem" class="list-item text-nowrap" href="whatsapp://send?text=={$node.url_alias|ezurl(no,full)|urlencode}" target="_blank" rel="noopener" aria-label="Share on Whatsapp">
                        {display_icon('it-whatsapp', 'svg', 'icon')}
                        <span>Whatsapp</span>
                    </a>
                </li>
            </ul>
        </div>
    </div>
</div>
<div class="dropdown">
    <button class="btn btn-dropdown dropdown-toggle text-decoration-underline d-inline-flex align-items-center fs-0" type="button" id="viewActions" data-toggle="dropdown" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false" aria-label="vedi azioni da compiere sulla pagina">
        {display_icon('it-more-items', 'svg', 'icon')}
        <small>{'Actions'|i18n('bootstrapitalia')}</small>
    </button>
    <div class="dropdown-menu shadow-lg" aria-labelledby="viewActions">
        <div class="link-list-wrapper">
            <ul class="link-list" role="menu">
                {*<li>
                    <a class="list-item text-nowrap" href="#">
                        {display_icon('it-download', 'svg', 'icon')}
                        <span>Scarica</span>
                    </a>
                </li>*}
                {*<li>
                    <a class="list-item text-nowrap" href="#" onclick="window.print();return false;">
                        {display_icon('it-print', 'svg', 'icon')}
                        <span>Stampa</span>
                    </a>
                </li>*}
                {*<li>
                    <a class="list-item text-nowrap" href="#">
                        {display_icon('it-hearing', 'svg', 'icon')}
                        <span>Ascolta</span>
                    </a>
                </li>*}
                <li>
                    <a role="menuitem" class="list-item text-nowrap" href="mailto:?subject={$node.name|wash()}&body={$node.url_alias|ezurl(no,full)}">
                        {display_icon('it-mail', 'svg', 'icon')}
                        <span>{'Send'|i18n('bootstrapitalia')}</span>
                    </a>
                </li>
                {if and($openpa.content_asl_organization.is_structure, $openpa.content_asl_organization.organization_node)}
                    <li>
                        <a role="menuitem" class="list-item text-nowrap" href="{concat($openpa.content_asl_organization.organization_node.url_alias, '#struttura')|ezurl(no)}">
                            {display_icon('it-info-circle', 'svg', 'icon icon-sm')} <span>Informazioni sull'unità organizzativa</span>
                        </a>
                    </li>
                {/if}
                {if and($openpa.content_asl_organization.is_organization, $openpa.content_asl_organization.structure_node)}
                    <li>
                        <a role="menuitem" class="list-item text-nowrap" href="{concat($openpa.content_asl_organization.structure_node.url_alias, '#struttura')|ezurl(no)}">
                            {display_icon('it-info-circle', 'svg', 'icon icon-sm')} <span>Informazioni sulla struttura</span>
                        </a>
                    </li>
                {/if}
            </ul>
        </div>
    </div>
</div>
