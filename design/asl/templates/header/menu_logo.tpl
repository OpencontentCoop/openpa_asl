{def $only_logo = cond(and( $pagedata.homepage|has_attribute('only_logo'), $pagedata.homepage|attribute('only_logo').data_int|eq(1) ), true(), false())}
{def $colorize_logo = cond(and($pagedata.header.logo.mime_type|eq('image/png'), and( $pagedata.homepage|has_attribute('colorize_logo'), $pagedata.homepage|attribute('colorize_logo').data_int|eq(1) )), true(), false())}
<a href="#" aria-label="home Nome del Comune" class="logo-hamburger">
    {if $pagedata.header.logo.url}
        <img class="icon {if $colorize_logo}colorize{/if} bg-primary"
             title="{ezini('SiteSettings','SiteName')}"
             alt="{ezini('SiteSettings','SiteName')}"
             src="{render_image($pagedata.header.logo.url|ezroot(no,full)).src}"
             style="width: auto !important;height:40px"/>
    {/if}
    <div class="it-brand-text">
        <div class="it-brand-title" style="font-size: 20px;line-height: 1;">{ezini('SiteSettings','SiteName')}</div>
    </div>
</a>
{undef $only_logo $colorize_logo }