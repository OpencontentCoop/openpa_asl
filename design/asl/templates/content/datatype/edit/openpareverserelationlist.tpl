{def $class_attribute_content = $attribute.class_content}
{if count($class_attribute_content.attribute_list)}
	<p class="m-0 text-secondary">Verranno visualizzati automaticamente tutti i contenuti di tipo:</p>
<ul>
	{foreach $class_attribute_content.attribute_list as $class_name => $relation_attributes}
		{foreach $relation_attributes as $relation_attribute}
			<li class="text-secondary"><em>{$class_name|wash()}</em> che sono correlati nel campo <em>{$relation_attribute.name|wash()}</em></li>
		{/foreach}
	{/foreach}
</ul>		
{/if}
{undef $class_attribute_content}