<?php /* #?ini charset="utf-8"?


[General]
AllowedTypes[]=Tags
AllowedTypes[]=SearchByTopicAndUserType
AllowedTypes[]=SearchBySubtree

[Tags]
Name=Tags
ManualAddingOfItems=disabled
UseBrowseMode[node_id]=true
CustomAttributes[]
CustomAttributes[]=tags
CustomAttributes[]=node_id
CustomAttributeNames[]
CustomAttributeNames[tags]=Percorsi tag
CustomAttributeNames[node_id]=Destinazione link
CustomAttributeTypes[]
CustomAttributeTypes[tags]=tag_tree_select
ViewList[]
ViewList[]=default
ViewName[]
ViewName[default]=Default
ItemsPerRow[]
Wide[]
CanAddShowAllLink=enabled
CanAddIntroText=enabled
ContainerStyle[]
ContainerStyle[default]=py-5

[Singolo]
CanAddShowAllLink=enabled

[SearchByTopicAndUserType]
Name=Ricerca per argomento e tipologia di utente
CustomAttributes[]
CustomAttributes[]=node_id
UseBrowseMode[node_id]=true
CustomAttributes[]=limite
CustomAttributes[]=includi_classi
CustomAttributes[]=input_search_placeholder
#CustomAttributes[]=view_api
CustomAttributes[]=base_query
CustomAttributeNames[]
CustomAttributeNames[limite]=Numero di elementi
CustomAttributeNames[includi_classi]=Tipologie di contenuto da includere
CustomAttributeNames[input_search_placeholder]=Placeholder input di ricerca
#CustomAttributeNames[view_api]=Tipologia di visualizzazione
CustomAttributeNames[base_query]=Query filter (Impostazione avanzata)
CustomAttributeTypes[]
CustomAttributeTypes[ordinamento]=select
CustomAttributeTypes[includi_classi]=class_select
#CustomAttributeTypes[view_api]=select
#CustomAttributeSelection_view_api[card_teaser]=Card (teaser)
#CustomAttributeSelection_view_api[card]=Card
#CustomAttributeSelection_view_api[banner]=Banner
#CustomAttributeSelection_view_api[latest_messages_item]=Lista
ManualAddingOfItems=disabled
ViewList[]
ViewList[]=default
ViewName[]
ViewName[default]=Default
ItemsPerRow[]
ContainerStyle[]
CanAddShowAllLink=enabled
CanAddIntroText=enabled
Wide[]
Wide[]=default

[SearchBySubtree]
Name=Ricerca per alberatura
NumberOfValidItems=15
NumberOfArchivedItems=0
ManualAddingOfItems=enabled
CustomAttributes[]
CustomAttributeNames[]
CustomAttributeTypes[]
ViewList[]
ViewList[]=default
ViewName[]
ViewName[default]=Default
ItemsPerRow[]
ContainerStyle[]
CanAddShowAllLink=enabled
CanAddIntroText=enabled
Wide[]
Wide[]=default
*/ ?>
