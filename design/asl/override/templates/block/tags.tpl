{def $openpa = object_handler($block)}

{set_defaults(hash('items_per_row', 3))}
{if $openpa.has_content}
{include uri='design:parts/block_name.tpl' no_margin=true()}

    <div class="row g-4">
        {foreach $openpa.content as $tag}
            <div class="col-12 col-md-6 col-lg-4">
                <div class="cmp-card-simple card-wrapper pb-0 border-bottom">
                    <div class="card">
                        <div class="card-body ps-0">
                            <a href="{concat($openpa.root_node.url_alias, '/(view)/', $tag.keyword)|ezurl(no)}"
                               class="text-decoration-none d-flex" data-focus-mouse="false">
                                <h3 class="card-title title-xlarge flex-grow-1">{$tag.keyword|wash()}</h3>
                                <div style="width: 30px;margin-top: 5px;text-align: right;">
                                    {display_icon('it-chevron-right', 'svg', 'icon icon-primary')}
                                </div>
                            </a>
                            <p class="titillium text-paragraph mb-0">
                                <span class="tag-description">{tag_description($tag.id, ezini('RegionalSettings', 'Locale'))|wash()|nl2br}</span>
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        {/foreach}
    </div>

{include uri='design:parts/block_show_all.tpl'}
{/if}
{unset_defaults(array('items_per_row'))}

{undef $openpa}