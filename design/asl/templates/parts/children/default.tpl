{set_defaults( hash(
  'page_limit', 24,
  'exclude_classes', openpaini( 'ExcludedClassesAsChild', 'FromFolder', array( 'image', 'infobox', 'global_layout' ) ),
  'include_classes', array(),
  'fetch_type', 'list',
  'parent_node', $node,
  'items_per_row', 3,
  'view_variation', '',
  'view', 'card_simple'
))}

{if $node.object.remote_id|eq('cb945b1cdaad4412faaa3a64f7cdd065')} {*documenti e dati*}
    {set $include_classes = array('pagina_sito', 'frontpage')}
{/if}

{if or(
    $node.object.remote_id|eq('3da91bfec50abc9740f0f3d62c8aaac4'),
    $node.parent.object.remote_id|eq('cb945b1cdaad4412faaa3a64f7cdd065'),
    $node.parent.object.remote_id|eq('news')
)}
    {set $view = 'card'}
{/if}

{def $topic_filter = concat('Users'|i18n('design/admin/setup/session'), ':user_types.name,', 'Topics'i18n('bootstrapitalia'), ':topics.name')}
{def $search_blocks = array()}
{if $openpa.content_tag_menu.current_view_tag}
    {if and($node.object.remote_id|eq('all-services'), $openpa.content_tag_menu.current_view_tag)}
        {set $search_blocks = array(page_block(
            "",
            "SearchByTopicAndUserType",
            "default",
            hash(
                "limite", "12",
                "includi_classi", "public_service",
                "input_search_placeholder", "Cerca un servizio o una prestazione",
                "view_api", "card_teaser",
                "base_query", concat("raw[ezf_df_tag_ids] = ", $openpa.content_tag_menu.current_view_tag.id)
                )
            )
        )}
    {elseif and($node.object.remote_id|eq('all-events'), $openpa.content_tag_menu.current_view_tag)}
        {set $search_blocks = array(page_block(
            "",
            "Eventi",
            "default",
            hash(
                "includi_classi", "event",
                "show_facets", "0",
                "topic_node_id", "",
                "tag_id", $openpa.content_tag_menu.current_view_tag.id,
                "size", "medium",
                "calendar_view", "day_grid",
                "color_style", "",
                "container_style", "",
                "max_events", "6",
                "intro_text", "",
                )
            )
        )}
    {elseif and($node.object.remote_id|eq('all-structures'), $openpa.content_tag_menu.current_view_tag)}
        {set $search_blocks = array(page_block(
            "",
            "OpendataRemoteContents",
            "default",
            hash(
                "remote_url", "",
                "query", concat("raw[ezf_df_tag_ids] in [", $openpa.content_tag_menu.current_view_tag_tree_list|implode(','), "] and classes [organization] and subtree [", $node.node_id, "]"),
                "show_grid", "1",
                "show_map", "1",
                "show_search", "1",
                "limit", "4",
                "items_per_row", "2",
                "facets", $topic_filter,
                "view_api", "card_teaser",
                "context_api", $node.node_id,
                "color_style", "bg-100",
                "fields", "",
                "template", "",
                "simple_geo_api", "1",
                "input_search_placeholder", ""
                )
            )
        )}
    {/if}
    {if count($search_blocks)}
        {include uri='design:zone/default.tpl' zones=array(hash('blocks', $search_blocks))}
    {/if}
{/if}

{if and(count($search_blocks)|eq(0), or($openpa.content_tag_menu.show_tag_cards|not(), $openpa.content_tag_menu.current_view_tag))}
    {if count($include_classes)}
        {def $params = hash( 'class_filter_type', 'include', 'class_filter_array', $include_classes )}
    {elseif count($exclude_classes)}
        {def $params = hash( 'class_filter_type', 'exclude', 'class_filter_array', $exclude_classes )}
    {/if}

    {if $openpa.content_tag_menu.current_view_tag}
        {set $params = $params|merge(hash(
          'extended_attribute_filter', hash(
              'id', TagsAttributeFilter,
              'params', hash(
                  'tag_id', $openpa.content_tag_menu.current_view_tag_tree_list,
                  'include_synonyms', true()
              )
          )
        ))}
        {set $fetch_type = 'tree'}
    {/if}
    {if $parent_node.object.remote_id|eq('topics')}
        {set $fetch_type = 'tree'}
        {set $page_limit = 150}
    {/if}

    {def $children_count = fetch( content, concat( $fetch_type, '_count' ), hash( 'parent_node_id', $parent_node.node_id )|merge( $params ) )}
    {if $children_count}
        {if $children_count|eq(2)}{set $items_per_row = 2}{/if}
        {def $children = fetch( content, $fetch_type, hash( 'parent_node_id', $parent_node.node_id,
                                                           'offset', $view_parameters.offset,
                                                           'sort_by', $parent_node.sort_array,
                                                           'limit', $page_limit )|merge( $params ) )}

        {if $node.object.remote_id|eq('topics')}
            {def $filtered_children = array()}
            {foreach $children as $child}
                {if $child.class_identifier|eq('topic')}
                    {if topic_has_contents($child.contentobject_id)}
                        {set $filtered_children = $filtered_children|append($child)}
                    {/if}
                {/if}
            {/foreach}
            {set $children = $filtered_children}
        {/if}

        <section id="{if $node|has_attribute('menu_name')}{$node|attribute('menu_name').content|slugize}{else}{$parent_node.name|slugize}{/if}" class="bg-light">
            <div class="container {$view_variation}">
                {if $openpa.content_tag_menu.current_view_tag|not()}
                    {if $node|has_attribute('menu_name')}
                        <h2 class="title-xxlarge mb-4">{$node|attribute('menu_name').content|wash()}</h2>
                    {else}
                        <h2 class="d-none">{$node.name|wash()}</h2>
                    {/if}
                {/if}

                {include uri='design:atoms/grid.tpl'
                         items_per_row=$items_per_row
                         i_view=$view
                         image_class='imagelargeoverlay'
                         view_variation='w-100'
                         grid_wrapper_class='row g-4'
                         show_icon = false()
                         show_category = false()
                         items=$children}

                {include name=navigator
                       uri='design:navigator/google.tpl'
                       page_uri=$node.url_alias
                       item_count=$children_count
                       view_parameters=$view_parameters
                       item_limit=$page_limit}

            </div>
        </section>
        {undef $children}
    {/if}
    {undef $params $children_count}
{/if}

{if $openpa.content_tag_menu.show_tag_cards}

    {def $locale = ezini('RegionalSettings', 'Locale')
         $tag_menu_children = array()
         $prefix = ''}
    {if $openpa.content_tag_menu.current_view_tag}
        {set $tag_menu_children = $openpa.content_tag_menu.current_view_tag.children
             $prefix = concat($openpa.content_tag_menu.current_view_tag.clean_url|explode(concat($openpa.content_tag_menu.tag_menu_root.clean_url, '/'))[1], '/')}
    {else}
        {set $tag_menu_children = $openpa.content_tag_menu.tag_menu_root.children}
    {/if}

    {def $show_all_tag_grid = array()} {*'all-services'*}
    {if $show_all_tag_grid|contains($node.object.remote_id)|not()}
        {def $clean_tag_menu_children = array()}
        {foreach $tag_menu_children as $tag}
            {if tag_tree_has_contents($tag, $node)}
                {set $clean_tag_menu_children = $clean_tag_menu_children|append($tag)}
            {/if}
        {/foreach}
        {set $tag_menu_children = $clean_tag_menu_children}
    {/if}

    {if $tag_menu_children|count()}
        <section id="{if $node|has_attribute('menu_name')}{$node|attribute('menu_name').content|slugize}{else}{$parent_node.name|slugize}{/if}" class="bg-light">
            <div class="container {$view_variation}">
                {if $node|has_attribute('menu_name')}
                    <h2 class="title-xxlarge mb-4">{$node|attribute('menu_name').content|wash()}</h2>
                {/if}
                <div class="row g-4">
                    {foreach $tag_menu_children as $tag}
                        <div class="col-12 col-md-6 col-lg-4">
                            <div class="cmp-card-simple card-wrapper pb-0 border-bottom">
                                <div class="card">
                                    <div class="card-body ps-0">
                                        <a href="{concat($openpa.content_tag_menu.tag_menu_root_node.url_alias, '/(view)/', $prefix, $tag.keyword)|ezurl(no)}"
                                           {if $node.object.remote_id|eq('all-services')}data-element="service-category-link"{/if}
                                           class="text-decoration-none d-flex" data-focus-mouse="false">
                                            <h3 class="card-title title-xlarge flex-grow-1">{$tag.keyword|wash()}</h3>
                                            <div style="width: 30px;margin-top: 5px;text-align: right;">
                                                {display_icon('it-chevron-right', 'svg', 'icon icon-primary')}
                                            </div>
                                        </a>
                                        <p class="titillium text-paragraph mb-0">
                                            <span class="tag-description">{tag_description($tag.id, $locale)|wash()|nl2br}</span>
                                            {if fetch( 'user', 'has_access_to', hash( 'module', 'bootstrapitalia', 'function', 'edit_tag_description' ) )}
                                                <a href="#" data-edit_tag="{$tag.id}" data-locale="{$locale}">
                                                    <span class="fa-stack">
                                                      <i aria-hidden="true" class="fa fa-circle fa-stack-2x"></i>
                                                      <i aria-hidden="true" class="fa fa-pencil fa-stack-1x fa-inverse"></i>
                                                    </span>
                                                </a>
                                            {/if}
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    {/foreach}
                </div>
            </div>
        </section>

        {if fetch( 'user', 'has_access_to', hash( 'module', 'bootstrapitalia', 'function', 'edit_tag_description' ) )}
            <script>{literal}
              $(document).ready(function () {
                $('[data-edit_tag]').on('click', function (e) {
                  let button = $(this);
                  let tagId = button.data('edit_tag');
                  let locale = button.data('locale');
                  let container = $(this).parent('p');
                  let text = container.find('span.tag-description').text();
                  container.hide();
                  let editContainer = $('<div></div>');
                  let textarea = $('<textarea rows="6" class="form-control form-control-sm text-sans-serif">'+$.trim(text)+'</textarea>')
                    .appendTo(editContainer);
                  let submitButton = $('<a href="#" data-tag="'+tagId+'" data-locale="'+locale+'" class="pull-right btn btn-xs btn-primary py-1 px-2 text-sans-serif mt-2">Salva</a>')
                    .appendTo(editContainer)
                    .on('click', function (e) {
                      let tagId = $(this).data('tag');
                      let locale = $(this).data('locale');
                      $.ez('ezjscedittagdescription::edit::'+tagId+'::'+locale+'::{/literal}{$node.contentobject_id}{literal}', {text: textarea.val()}, function (response) {
                        if (response.result === 'success'){
                          $('[data-edit_tag="'+response.tag+'"]').parent('p').find('span.tag-description').text(response.text);
                        }
                        editContainer.remove();
                        container.show();
                      })
                      e.preventDefault();
                    });
                  let cancelButton = $('<a href="#" class="pull-right btn btn-xs btn-info py-1 px-2 text-sans-serif mt-2 mr-2 me-2">Annulla</a>')
                    .appendTo(editContainer)
                    .on('click', function (e) {
                      editContainer.remove();
                      container.show();
                      e.preventDefault();
                    });
                  editContainer.insertBefore(container);
                  e.preventDefault();
                });
              })
            {/literal}</script>
        {/if}
    {/if}
    {undef $tag_menu_children $locale $clean_tag_menu_children $show_all_tag_grid}
{/if}
{undef $search_blocks}

{unset_defaults( array(
    'page_limit',
    'exclude_classes',
    'include_classes',
    'fetch_type',
    'parent_node',
    'items_per_row'
) )}