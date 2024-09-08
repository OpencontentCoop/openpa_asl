<div class="cmp-card-simple card-wrapper pb-0 border-bottom {$node|access_style}">
    <div class="card">
        <div class="card-body ps-1">
            <a href="{$openpa.content_link.full_link}#page-content" data-element="{$openpa.data_element.value|wash()}" class="text-decoration-none d-flex">
                <h3 class="card-title title-xlarge flex-grow-1">
                    {$node.name|wash()}
                    {include uri='design:parts/card_title_suffix.tpl'}
                </h3>
                <div style="width: 30px;margin-top: 5px;text-align: right;">
                    {display_icon('it-chevron-right', 'svg', 'icon icon-primary')}
                </div>
            </a>
            {if and($openpa.content_link.is_node_link|not(), $node.can_edit)}
                <a href="{$node.url_alias|ezurl(no)}">
                            <span class="fa-stack">
                              <i aria-hidden="true" class="fa fa-circle fa-stack-2x"></i>
                              <i aria-hidden="true" class="fa fa-wrench fa-stack-1x fa-inverse"></i>
                            </span>
                </a>
            {/if}
            <div class="m-0">
                {attribute_view_gui attribute=$node|attribute('abstract')}
            </div>
        </div>
    </div>
</div>
