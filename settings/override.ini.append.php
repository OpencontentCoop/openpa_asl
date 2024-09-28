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
[pagina_sito_as_structure_tag]
Source=node/view/full.tpl
MatchFile=full/pagina_sito_as_structure_tag.tpl
Subdir=templates
Match[class_identifier]=pagina_sito
Match[parent_object_remote_id]=all-structures

[dataset_as_structure_tag]
Source=node/view/full.tpl
MatchFile=full/dataset_as_structure_tag.tpl
Subdir=templates
Match[class_identifier]=dataset
Match[parent_object_remote_id]=all-structures

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

[block_user_type_topic_search_map]
Source=block/view/view.tpl
MatchFile=block/user_type_topic_search_map.tpl
Subdir=templates
Match[type]=SearchByTopicAndUserType
Match[view]=map

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

[datatype_view_bando_concorso_is_open]
Source=content/datatype/view/ezboolean.tpl
MatchFile=datatype/view/boolean_bando_concorso_is_open.tpl
Subdir=templates
Match[class_identifier]=bando_concorso
Match[attribute_identifier]=is_open

[datatype_view_public_service_is_physically_available_at]
Source=content/datatype/view/ezobjectrelationlist.tpl
MatchFile=datatype/view/relations_map.tpl
Subdir=templates
Match[class_identifier]=public_service
Match[attribute_identifier]=is_physically_available_at