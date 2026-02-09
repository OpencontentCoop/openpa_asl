<?php /* #?ini charset="utf-8"?

[BlockHandlers]
Handlers[Tags/*]=OpenPABlockHandlerTags

[HideRelationsTitle]
# set in siteaccess/.../openpa.ini
AttributeIdentifiers[]

[SideMenu]
IdentificatoriMenu[]=user_type

[TopMenu]
LimitePrimoLivello=30
LimiteSecondoLivello=30
LimiteTerzoLivello=30

[ObjectHandlerServices]
Services[content_asl_organization]=ObjectHandlerServiceContentAslOrganization

[AttributeHandlers]
UniqueStringCheck[]=document/has_code
UniqueStringCheck[]=lotto/cig
UniqueStringCheck[]=public_service/identifier

InputValidators[]
InputValidators[]=OrganizationValidator
InputValidators[]=EventOrganizationValidator
InputValidators[]=BandoRankingValidator

[FooterLinks]
Inefficiency=disabled
Helpdesk=enabled
Booking=enabled

[ChildrenFilters]
TopicsCountQuery=

[MonitoraggioPS]
ScriptSrc=https://s3.eu-west-1.amazonaws.com/static.opencityitalia.it/widgets/attesa-ps/version/0.2.3/bootstrap-italia%402/js/web-formio.js
*/ ?>
