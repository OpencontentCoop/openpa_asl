<?php /* #?ini charset="utf-8"?

############################################
############################################ CHILDREN
############################################
[children_structure]
Source=node/view/children.tpl
MatchFile=children/structures.tpl
Subdir=templates
Match[remote_id]=all-structures

############################################
############################################ FULL
############################################
[medici_di_base_pediatri]
Source=node/view/full.tpl
MatchFile=full/medici_di_base_pediatri.tpl
Subdir=templates
Match[remote_id]=medici_di_base_pediatri

[organization_as_structure]
Source=node/view/full.tpl
MatchFile=full/organization_as_structure.tpl
Subdir=templates
Match[parent_object_remote_id]=all-structures

############################################
############################################ BLOCK
############################################

[block_tags]
Source=block/view/view.tpl
MatchFile=block/tags.tpl
Subdir=templates
Match[type]=Tags
Match[view]=default

[block_user_type_topic_search]
Source=block/view/view.tpl
MatchFile=block/user_type_topic_search.tpl
Subdir=templates
Match[type]=SearchByTopicAndUserType
Match[view]=default

[block_tree_search]
Source=block/view/view.tpl
MatchFile=block/tree_search.tpl
Subdir=templates
Match[type]=SearchBySubtree
Match[view]=default


############################################
############################################ DATATYPE VIEW
############################################

[datatype_view_related_offices]
Source=content/datatype/view/openpareverserelationlist.tpl
MatchFile=datatype/view/openpareverserelationlist_list.tpl
Subdir=templates
Match[attribute_identifier]=related_offices

[datatype_view_steps]
Source=content/datatype/view/ezobjectrelationlist.tpl
MatchFile=datatype/view/relations_howto_steps.tpl
Subdir=templates
Match[class_identifier]=howto
Match[attribute_identifier]=steps

[datatype_view_public_service_howto]
Source=content/datatype/view/ezobjectrelationlist.tpl
MatchFile=datatype/view/relations_public_service_howto.tpl
Subdir=templates
Match[class_identifier]=public_service
Match[attribute_identifier]=how_to
