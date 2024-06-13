{ezpagedata_set( 'has_container', true() )}
{ezpagedata_set( 'has_sidemenu', false() )}
{ezpagedata_set( 'show_path',false() )}

<div class="container" id="main-container">
    <div class="row justify-content-center">
        <div class="col-12">
            <div class="cmp-breadcrumbs" role="navigation">
                <nav class="breadcrumb-container" aria-label="breadcrumb">
                    <ol class="breadcrumb p-0" data-element="breadcrumb">
                        <li class="breadcrumb-item">
                            <a href="{'/'|ezurl(no)}">Home</a>
                            <span class="separator">/</span>
                        </li>
                        <li class="breadcrumb-item active" aria-current="page">
                            {$node.name|wash()}
                        </li>
                    </ol>
                </nav>
            </div>
        </div>
    </div>
</div>

<div class="container">
    <div class="row">
        <div class="col-12 col-lg-10">
            <div class="cmp-hero">
                <section class="it-hero-wrapper bg-white d-block">
                    <div class="it-hero-text-wrapper pt-0 ps-0 pb-2">
                        <h1 class="text-black hero-title" data-element="page-name">
                            {$node.name|wash()}
                        </h1>
                        <div class="hero-text">
                            {include uri='design:openpa/full/parts/main_attributes.tpl'}
                        </div>
                    </div>
                </section>
            </div>
        </div>
    </div>
</div>



{def $blocks = array()}
{if $node|has_attribute('layout')}
    {set $blocks = $node|attribute('layout').content.zones[0].blocks}
{/if}

{def $nodes = array(fetch(content,node, hash('node_id', 2)))}
{foreach openpaini( 'TopMenu', 'NodiCustomMenu', array() ) as $id}
    {set $nodes = $nodes|append(fetch(content, node, hash(node_id, $id)))}
{/foreach}
{def $doc_id = 'cb945b1cdaad4412faaa3a64f7cdd065'|node_id_from_object_remote_id()}
{if $doc_id}
    {set $nodes = $nodes|append(fetch(content, node, hash(node_id, $doc_id)))}
{/if}
{set $blocks = $blocks|append(page_block(
    '',
    "SearchBySubtree",
    "default",
    hash(
        'user_type_node_id', $node.node_id
    ),
    $nodes
))}

{if $blocks|count()}
    {include uri='design:zone/default.tpl' zones=array(hash('blocks', $blocks))}
{/if}
