{def $background_image = false()}
{if and(is_set($block.custom_attributes.image), $block.custom_attributes.image|ne(''))}
    {def $image = fetch(content, node, hash(node_id, $block.custom_attributes.image))}
    {if and($image, $image.class_identifier|eq('image'), $image|has_attribute('image'))}
        {set $background_image = $image|attribute('image').content.original.full_path|ezroot(no)}
    {/if}
    {undef $image}
{/if}
<div class="section section-muted p-0 py-5 bg-light">
    <div class="container">
        <div class="row">
            <div class="col col-lg-6">
                <h2 class="h5">{$block.name|wash()}</h2>
                <div class="cmp-input-search">
                    <form action="{'/content/search/'|ezurl(no)}" method="get" class="form-group autocomplete-wrapper{if $background_image|not()} mb-2 mb-lg-4{/if}">
                        <div class="input-group">
                            <label for="{$block.id}-search" class="visually-hidden">{'Search'|i18n('design/plain/layout')}</label>
                            <input type="search" class="autocomplete form-control" id="{$block.id}-search" name="SearchText" data-bs-autocomplete="[]" data-focus-mouse="false">

                            <div class="input-group-append">
                                <button class="btn btn-primary" type="submit" id="button-3">{'Search'|i18n('design/plain/layout')}</button>
                            </div>

                            <span class="autocomplete-icon" aria-hidden="true">
                                {display_icon('it-search', 'svg', 'icon icon-sm icon-primary', 'Search'|i18n('design/plain/layout'))}
                            </span>
                        </div>
                    </form>
                </div>
            </div>
            <div class="col-12">
                {def $terms = array()}
                {if and(is_set($block.custom_attributes.search_terms), $block.custom_attributes.search_terms|ne(''))}
                    {def $parts = $block.custom_attributes.search_terms|explode('|')}
                    {foreach $parts as $part}
                        {def $labelAndValue = $part|explode('=>')}
                        {set $terms = $terms|append(hash(
                            'url', concat('content/search?SearchText=', $labelAndValue[1]|wash()),
                            'label', $labelAndValue[0]
                        ))}
                        {undef $labelAndValue}
                    {/foreach}
                    {undef $parts}
                {/if}
                {if or(count($terms)|gt(0), count($block.valid_nodes)|gt(0))}
                <h3 class="h6 text-muted">{'Useful links'|i18n( 'bootstrapitalia' )}</h3>
                <ul class="list-inline" role="list">
                    {if count($block.valid_nodes)|gt(0)}
                        {foreach $block.valid_nodes as $valid_node max 6}
                            <li class="list-inline-item">
                                {node_view_gui content_node=$valid_node a_class="text-muted" view=text_linked show_icon=false()}
                            </li>
                        {/foreach}
                    {/if}
                    {if count($terms)|gt(0)}
                        {foreach $terms as $term max 6}
                            <li class="list-inline-item">
                                <a class="text-muted" href="{$term.url|ezurl(no)}">{$term.label|wash()}</a>
                            </li>
                        {/foreach}
                    {/if}
                </ul>
                {/if}
                {undef $terms}
            </div>
        </div>
    </div>
</div>