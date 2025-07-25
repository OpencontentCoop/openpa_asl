{set_defaults(hash('first_wrapper_color_style', false()))}
{def $block_wrappers = parse_layout_blocks($zones).wrappers}

{if count($block_wrappers)|gt(0)}
{foreach $block_wrappers as $index => $block_wrapper}
  {def $next_index = $index|inc()
       $prev_index = $index|sub(1)}

  {def $block_wrapper_color_style = $block_wrapper.color_style}

  {if and($index|eq(0), $first_wrapper_color_style)}
      {set $block_wrapper_color_style = $first_wrapper_color_style}
  {/if}

  {set $block_wrapper_color_style = $block_wrapper_color_style|explode('bg-grey-card')|implode('bg-light')}

  {def $block_section_style = $block_wrapper.layout_style}
  {def $block_wrapper_container_style = concat($block_wrapper_color_style, ' ', $block_wrapper.container_style)|trim()}

  {if and(is_set($block_wrappers[$next_index].layout_style),$block_wrappers[$next_index].layout_style)}
    {set $block_section_style = concat($block_section_style, ' before-', $block_wrappers[$next_index].layout_style)}
  {/if}
  {if and(is_set($block_wrappers[$prev_index].layout_style),$block_wrappers[$prev_index].layout_style)}
    {set $block_section_style = concat($block_section_style, ' after-', $block_wrappers[$prev_index].layout_style)}
  {/if}

  <section class="page-{$#node.class_identifier} {$block_section_style}" id="{$block_wrapper.slug}">
    {if $block_wrapper_container_style}<div class="{$block_wrapper_container_style}">{/if}
    {if $block_wrapper.is_wide|not()}<div class="container">{/if}

    {block_view_gui block_index=$index block=$block_wrapper.block items_per_row=$block_wrapper.items_per_row container_styles=$block_wrapper_container_style|explode(' ') is_homepage=cond(fetch('openpa', 'homepage').node_id|eq($#node.node_id), true(), false())}

    {if $block_wrapper.is_wide|not()}</div>{/if}
    {if $block_wrapper_container_style}</div>{/if}

  </section>

  {undef $next_index $prev_index $block_section_style $block_wrapper_container_style $block_wrapper_color_style}
{/foreach}
{/if}
{undef $block_wrappers}