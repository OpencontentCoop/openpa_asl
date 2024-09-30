{def $only_logo = cond(and( $pagedata.homepage|has_attribute('only_logo'), $pagedata.homepage|attribute('only_logo').data_int|eq(1) ), true(), false())}
{def $header_is_white = cond(header_color()|begins_with('#fff'), true(), false())}

<a href="#" aria-label="home Nome del Comune" class="logo-hamburger">
    {if $pagedata.header.logo.url}
        <img class="icon{if $header_is_white|not()} bg-primary p-1 rounded{/if}"
             title="{ezini('SiteSettings','SiteName')}"
             alt="{ezini('SiteSettings','SiteName')}"
             src="{render_image($pagedata.header.logo.url|ezroot(no,full)).src}"
             style="width: auto !important;height:{if $header_is_white|not()}50{else}40{/if}px"/>
    {/if}
    <div class="it-brand-text">
        <div class="it-brand-title" style="font-size: 20px;line-height: 1;">{ezini('SiteSettings','SiteName')}</div>
    </div>
</a>
{undef $only_logo $header_is_white}