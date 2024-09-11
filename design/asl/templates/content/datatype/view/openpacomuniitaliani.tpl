{def $content = $attribute.content}
<div class="d-flex flex-wrap gap-2 mt-10 mb-30 font-sans-serif">
{foreach $content as $item}
    <div class="chip chip-simple chip-primary text-button border-primary rounded-2"><span class="chip-label lh-sm px-2">{$item.name|wash}</span></div>
{/foreach}
</div>
