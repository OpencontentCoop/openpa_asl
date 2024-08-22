<header class="it-header-wrapper it-header-sticky" data-bs-toggle="sticky" data-bs-position-type="fixed"
        data-bs-sticky-class-name="is-sticky" data-bs-target="#header-nav-wrapper" style="z-index: 6">
    {include uri='design:page_toolbar.tpl'}
    {include uri='design:header/service.tpl'}

    <div class="it-nav-wrapper">
        <div class="it-header-center-wrapper{if current_theme_has_variation('light_center')} theme-light{/if}">
            <div class="container">
                <div class="row">
                    <div class="col-12">
                        <div class="it-header-center-content-wrapper">
                            {include uri='design:logo.tpl'}
                            <div class="it-right-zone">
                                {include uri='design:header/social.tpl' css="d-none d-lg-flex"}
                                {include uri='design:header/search.tpl'}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        {include uri='design:header/navbar.tpl'}
    </div>
    {if $pagedata.homepage|has_attribute('main_phone_contacts')}
    <div class="border-bottom py-2 bg-light">
        <div class="container overflow-hidden">
            <div class="d-flex justify-content-sm-center justify-content-md-start">
                {foreach $pagedata.homepage|attribute('main_phone_contacts').content.rows.sequential as $row}
                <small class="text-xs-center text-sm-center text-md-start text-nowrap px-2 px-lg-0 pe-lg-5">
                    <span class="d-none d-lg-inline-block">{$row.columns[0]|wash()}</span>
                    {def $value = $row.columns[2]}
                    {if or($value|begins_with('http'), $value|begins_with('/'))}
                        <a href="{$value|wash()}"><strong>{$row.columns[1]|wash()}</strong></a>
                    {else}
                        <strong>{$row.columns[1]|wash()}
                        <a href="tel:{$value|wash()}">{$value|wash()}</a></strong>
                        {display_icon('it-telephone', 'svg', 'icon icon-sm align-top d-none d-lg-inline-block')}
                    {/if}
                    {undef $value}
                </small>
                {/foreach}
            </div>
        </div>
    </div>
    {/if}
</header>