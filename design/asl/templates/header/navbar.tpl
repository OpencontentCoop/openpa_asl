{def $top_menu_node_ids = array()
	 $selected_topic_list = array()
	 $topic_menu_label = 'All topics...'|i18n('bootstrapitalia')
	 $topics = false()
	 $topic_list = array()
     $show_topic_menu = true()
     $show_children = false()}

{if $pagedata.homepage|has_attribute('show_extended_menu')}
    {set $show_children = cond($pagedata.homepage|attribute('show_extended_menu').data_int|eq(1), true(), false())}
{/if}

{if and( $pagedata.is_login_page|not(), array( 'edit', 'browse' )|contains( $ui_context )|not(), openpaini( 'TopMenu', 'ShowMegaMenu', 'enabled' )|eq('enabled') )}
    {def $is_area_tematica = is_area_tematica()}
    {if and($is_area_tematica, $is_area_tematica|has_attribute('link_al_menu_orizzontale'))}
        {set $top_menu_node_ids = array()}
        {foreach $is_area_tematica|attribute('link_al_menu_orizzontale').content.relation_list as $item}
            {set $top_menu_node_ids = $top_menu_node_ids|append($item.node_id)}
        {/foreach}
    {else}
        {set $top_menu_node_ids = openpaini( 'TopMenu', 'NodiCustomMenu', array() )}
    {/if}
    {undef $is_area_tematica}
{/if}
<div id="header-nav-wrapper" class="it-header-navbar-wrapper{if current_theme_has_variation('light_center')} theme-light{/if} {if current_theme_has_variation('light_navbar')} theme-light-desk border-bottom{/if}">
    <div class="container">
        <div class="row">
            <div class="col-12">
                <nav class="navbar navbar-expand-lg has-megamenu" aria-label="{'Main menu'|i18n('bootstrapitalia')}">
                    <button class="custom-navbar-toggler"
                            type="button"
                            aria-controls="main-menu"
                            aria-expanded="false"
                            aria-label="{'Toggle navigation'|i18n('bootstrapitalia')}"
                            title="{'Toggle navigation'|i18n('bootstrapitalia')}"
                            data-bs-target="#main-menu"
                            data-bs-toggle="navbarcollapsible">
                        {display_icon('it-burger', 'svg', 'icon', 'Toggle navigation'|i18n('bootstrapitalia'))}
                    </button>
                    <div class="navbar-collapsable" id="main-menu">
                        <div class="overlay" style="display: none;"></div>
                        <div class="close-div">
                            <button class="btn close-menu" type="button">
                                <span class="visually-hidden">{'hide navigation'|i18n('bootstrapitalia')}</span>
                                {display_icon('it-close-big', 'svg', 'icon', 'hide navigation'|i18n('bootstrapitalia'))}
                            </button>
                        </div>
                        <div class="menu-wrapper">
                            {include uri='design:header/menu_logo.tpl'}
                            <ul class="navbar-nav" data-element="main-navigation">
                            {foreach $top_menu_node_ids as $id}
                                {def $tree_menu = tree_menu( hash( 'root_node_id', $id, 'scope', 'top_menu'))}
                                {include name=top_menu
                                         uri='design:header/menu_item.tpl'
                                         show_children=$show_children
                                         menu_item=$tree_menu}
                                {undef $tree_menu}
                            {/foreach}
                            </ul>
                            {include uri='design:header/social.tpl' split_at=6}
                        </div>
                    </div>
                </nav>
            </div>
        </div>
    </div>
</div>
<script>{literal}
$(document).ready(function() {
    $('#main-menu a').each(function (e) {
        var node = $(this).data('node');
        if (node) {
            var href = $(this).attr('href');
            if (UiContext === 'browse') {
                href = '/content/browse/' + node;
            }
            $(this).attr('href', href);
            var self = $(this);
            $.each(PathArray, function (i, v) {
                if (v === node) {
                    self.addClass('active').parents('li').addClass('active');
                    if (i === 0) {
                        self.addClass('active').parents('li').addClass('active');
                    }
                }
            });
        }
    });
});
{/literal}</script>
{undef $top_menu_node_ids $topics $topic_list}