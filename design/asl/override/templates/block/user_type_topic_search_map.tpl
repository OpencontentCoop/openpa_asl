{def $attributes = array(
    hash(
        'identifier', 'user_types',
        'root_node', 1,
        'class_constraint_list', array('user_type'),
        'name', 'Utenti',
        'fetch_function', 'tree'
    ),
    hash(
        'identifier', 'topics',
        'root_node', fetch(content, object, hash(remote_id, 'topics')).main_node_id,
        'class_constraint_list', array('topic'),
        'name', 'Argomenti',
        'fetch_function', 'list'
    )
)}

<form id="main-search-{$block.id}"
      data-base_query="{$block.custom_attributes.base_query|wash()}"
      data-context="{cond(is_set($block.custom_attributes.context_api), $block.custom_attributes.context_api|wash(), '')}"
      data-classes="{$block.custom_attributes.includi_classi|wash()}"
      data-limit="{$block.custom_attributes.limite|wash()}">

    <section class="bg-light border-top py-5">
        <div class="container">
            <div class="row">
                <div class="col-lg-12 pr-0">
                    <div class="sorters row">
                        <div class="col-12 col-sm-8 pb-4">
                            {if $block.custom_attributes.input_search_placeholder|ne('')}
                            <h2 class="h5">{$block.custom_attributes.input_search_placeholder|wash()}</h2>
                            {/if}

                            <div class="cmp-input-search position-relative">
                                <div class="form-group">
                                    <div class="input-group">
                                        <label for="{$block.id}-search" class="visually-hidden">{'Search'|i18n('design/plain/layout')}</label>
                                        <input placeholder="{'Search by keyword'|i18n('bootstrapitalia')}" type="search" class="autocomplete form-control" id="{$block.id}-search" name="q" data-bs-autocomplete="[]" data-focus-mouse="false">
                                        <div class="input-group-append">
                                            <button class="btn btn-primary rounded-0" type="submit" id="button-3">{'Search'|i18n('design/plain/layout')}</button>
                                        </div>
                                        <span class="autocomplete-icon" aria-hidden="true">
                                            {display_icon('it-search', 'svg', 'icon icon-sm icon-primary', 'Search'|i18n('design/plain/layout'))}
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12 col-sm-8">
                            <div id="main-search-{$block.id}-map" style="width: 100%; height:400px"></div>
                        </div>
                        <div class="col-12 col-sm-4">
                            <div class="row">
                                <div class="col-5 py-3 py-sm-0" data-result_decoration  style="display:none">
                                    <div class="bootstrap-select-wrapper lh-lg">
                                        <span class="font-weight-bold" data-count></span> {'contents found'|i18n('bootstrapitalia')}
                                    </div>
                                </div>
                                <div class="col-7 text-end  py-3 py-sm-0" data-result_decoration  style="display:none">
                                    <label class="me-1" for="Sort">{'Sorting by'|i18n('openpa/search')}</label>
                                    <select data-param="sort" class="rounded" id="Sort">
                                        <option value="published">{'Publication date'|i18n('openpa/search')}</option>
                                        <option selected="selected" value="name">{'Name'|i18n('openpa/search')}</option>
                                    </select>
                                    <label class="d-none" for="Order">Direction</label>
                                    <select data-param="direction" class="rounded" id="Order">
                                        <option selected="selected" value="asc">A-Z</option>
                                        <option value="desc">Z-A</option>
                                    </select>
                                </div>
                            </div>
                            <div class="results"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</form>

{ezscript_require(array('jsrender.js'))}

{literal}
    <script id="tpl-results" type="text/x-jsrender">
	<div class="card-wrapper card-teaser-wrapper card-teaser-masonry-wrapper">
	{{for searchHits}}
		{{:~i18n(extradata, 'view')}}
	{{/for}}
	</div>

	{{if pageCount > 1}}
        <div class="row mt-lg-4">
            <div class="col">
                <nav class="pagination-wrapper justify-content-center" aria-label="Pagination">
                    <ul class="pagination">
                        <li class="page-item {{if !prevPageQuery}}disabled{{/if}}">
                            <a class="page-link prevPage" {{if prevPageQuery}}data-page="{{>prevPage}}"{{/if}} href="#">
                                <svg class="icon icon-primary">
                                    <use xlink:href="/extension/openpa_bootstrapitalia/design/standard/images/svg/sprite.svg#it-chevron-left"></use>
                                </svg>
                                <span class="sr-only">Pagina precedente</span>
                            </a>
                        </li>
                        <!--{{for pages ~current=currentPage}}
                            <li class="page-item"><a href="#" class="page-link page" data-page_number="{{:page}}" data-page="{{:query}}"{{if ~current == query}} data-current aria-current="page"{{/if}}>{{:page}}</a></li>
                        {{/for}}-->
                        <li class="page-item {{if !nextPageQuery}}disabled{{/if}}">
                            <a class="page-link nextPage" {{if nextPageQuery}}data-page="{{>nextPage}}"{{/if}} href="#">
                                <span class="sr-only">Pagina successiva</span>
                                <svg class="icon icon-primary">
                                    <use xlink:href="/extension/openpa_bootstrapitalia/design/standard/images/svg/sprite.svg#it-chevron-right"></use>
                                </svg>
                            </a>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>
        {{/if}}
</script>
<script id="tpl-spinner" type="text/x-jsrender">
<div class="col-xs-12 spinner text-center py-3 py-sm-0">
    <i class="fa fa-circle-o-notch fa-spin fa-3x fa-fw"></i>
</div>
</script>
<script id="tpl-empty" type="text/x-jsrender">
<div class="col-xs-12 text-center">
    <a href="#" class="text-decoration-none" data-reset><i class="fa fa-times"></i> {/literal}{'No results were found'|i18n('openpa/search')}{literal}</a>
</div>
</script>

<script>
  $(document).ready(function () {
    $.views.helpers($.opendataTools.helpers);
    $.opendataTools.settings('accessPath', "{/literal}{''|ezurl(no)}{literal}");
    $.opendataTools.settings('language', "{/literal}{ezini('RegionalSettings', 'Locale')}{literal}");
    $.opendataTools.settings('locale', "{/literal}{ezini('RegionalSettings', 'Locale')|explode('-')[1]|downcase()}{literal}");
    let defaultLat = parseFloat('{/literal}{cond(openpapagedata().contacts.latitudine|ne(''), openpapagedata().contacts.latitudine, 0)}{literal}');
    let defaultLng = parseFloat('{/literal}{cond(openpapagedata().contacts.longitudine|ne(''), openpapagedata().contacts.longitudine, 0)}{literal}');
    let baseId = '{/literal}main-search-{$block.id}{literal}';
    let i18n = {
      no_suggestion_message: "{/literal}{'No results were found'|i18n('openpa/search')}{literal}"
    }
    let form = $('#'+baseId);
    let classes = form.data('classes').split(',');
    let currentPage = 0;
    let queryPerPage = [];
    let limitPagination = form.data('limit') || 6;
    let baseQuery = form.data('base_query') + ' and facets [user_types.id,topics.id] and classes [' + classes.join(',') + ']';
    let searchQuery;
    let resultsContainer = form.find('.results');
    let template = $.templates('#tpl-results');
    let spinner = $.templates('#tpl-spinner');
    let noResults = $.templates('#tpl-empty');
    let detectError = function (response, jqXHR) {
      if (response.error_message || response.error_code) {
        console.log(response.error_code, response.error_message, jqXHR);
        return true;
      }
      return false;
    };
    let find = function (query, cb, context) {
      $.ajax({
        type: 'GET',
        url: $.opendataTools.settings('endpoint').search,
        data: {
          q: query,
          view: 'card_teaser',
          context: form.data('context')
        },
        contentType: 'application/json; charset=utf-8',
        dataType: 'json',
        success: function (data, textStatus, jqXHR) {
          if (!detectError(data, jqXHR)) {
            cb.call(context, data);
          }
        },
        error: function (jqXHR) {
          let error = {
            error_code: jqXHR.status,
            error_message: jqXHR.statusText
          };
          detectError(error, jqXHR);
        }
      });
    };
    let geoJsonFindAll = function (query, cb, context) {
      let features = [];
      let geoJsonFind = function (query, cb, context) {
        $.ajax({
          type: "GET",
          url: $.opendataTools.settings('endpoint').geo,
          data: {
            q: query,
            context: form.data('context')
          },
          dataType: 'json',
          success: function (response,textStatus,jqXHR) {
            if (!detectError(response,jqXHR)){
              if ($.isFunction(cb)) {
                cb.call(context, response);
              }
            }
          },
          error: function (jqXHR) {
            let error = {
              error_code: jqXHR.status,
              error_message: jqXHR.statusText
            };
            detectError(error,jqXHR);
          }
        });
      };
      let getSubRequest = function (query) {
        geoJsonFind(query, function (data) {
          parseSubResponse(data);
        });
      };
      let parseSubResponse = function (response) {
        if (response.features.length > 0) {
          $.each(response.features, function () {
            features.push(this);
          });
        }
        if (response.nextPageQuery) {
          getSubRequest(response.nextPageQuery);
        } else {
          let featureCollection = {
            'type': 'FeatureCollection',
            'features': features
          };
          cb.call(context, featureCollection);
        }
      };
      getSubRequest(query);
    };
    let markerBuilder = function (response) {
      return L.geoJson(response, {
        pointToLayer: function (feature, latlng) {
          return L.marker(latlng, {icon: L.divIcon({
              html: '<i class="fa fa-map-marker fa-4x text-primary"></i>',
              iconSize: [20, 20],
              className: 'myDivIcon'
            })});
        },
        onEachFeature: function (feature, layer) {
          let href = feature.properties.urlAlias || '/content/view/full/' + feature.properties.mainNodeId;
          let popupDefault = `
            <div class="card-wrapper border border-light rounded shadow-sm pb-0">
              <div class="card no-after rounded bg-white">
                <div class="card-body">
                  <h6 class="font-sans-serif">
                    <a href="${href}" target="_blank">${feature.properties.name}</a>
                  </h6>
                  <p class="font-sans-serif">
                    ${feature.properties.address || feature.properties.geo}
                  </p>
                </div>
              </div>
            </div>
          `;
          let popup = new L.Popup({maxHeight: 400, minWidth: 300});
          popup.setContent(popupDefault);
          layer.bindPopup(popup);
        }
      });
    };
    let isFiltersBuilt = false;
    let map = L.map(baseId + '-map').setView([defaultLat, defaultLng], defaultLat !== 0 ? 10 : 1);
    map.scrollWheelZoom.disable();
    L.tileLayer('//{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'}).addTo(map);
    let markers = L.markerClusterGroup().addTo(map);
    form.find('[data-param], input[type="checkbox"], input[type="radio"]').on('change', function () {
      form.trigger('submit');
    });
    form.on('submit', function (e) {
      let formSerializeArray = $(this).serializeArray();
      let d = {};
      $.each(formSerializeArray, function () {
        if (this.value.length > 0 && this.name !== 'address') {
          let value = this.value.replace(/"/g, '').replace(/'/g, "").replace(/\(/g, "").replace(/\)/g, "").replace(/\[/g, "").replace(/\]/g, "");
          if (d[this.name] !== undefined) {
            d[this.name].push(value);
          } else {
            d[this.name] = [value];
          }
        }
      });
      let query = [baseQuery];
      $.each(d, function (i, v) {
        if (i === 'q')
          query.push(i + ' = \'' + v.join(' ') + '\'');
        else
          query.push(i + ' in [\'' + v.join('\',\'') + '\']');
      });
      let sort = $('[data-param="sort"]').val();
      let direction = $('[data-param="direction"]').val();
      query.push('sort [' + sort + '=>' + direction + ']');

      searchQuery = query.join(' and ');
      currentPage = 0;
      queryPerPage = [];
      loadMapContents();
      loadSearchBlockContents();

      e.preventDefault();
    });
    let loadMapContents = function () {
      markers.clearLayers();
      geoJsonFindAll(searchQuery, function (response) {        
        if (response.features.length > 0) {
          let geoJsonLayer = markerBuilder(response);
          markers.addLayer(geoJsonLayer);
          map.fitBounds(markers.getBounds());
        }
      });
    };
    let loadSearchBlockContents = function () {
      let paginatedQuery = searchQuery + ' and limit ' + limitPagination + ' offset ' + currentPage * limitPagination;
      resultsContainer.html($(spinner.render({})));
      find(paginatedQuery, function (response) {
        if (!isFiltersBuilt){
          $.each(response.facets, function () {
            let facet = this;
            $.each(facet.data, function (filterId, count) {
              $('[data-filter="'+filterId+'"]').show();
            });
          });
          isFiltersBuilt = true;
        }

        let dataResultDecoration = form.find('[data-result_decoration]')
        let dataCountContainer = form.find('[data-count]');
        dataCountContainer.html(response.totalCount);
        if (response.totalCount === 0) {
          dataResultDecoration.hide();
          resultsContainer.html($(noResults.render(response)));
          resultsContainer.find('[data-reset]').on('click', function (e) {
            resetSearchBlockContents();
            e.preventDefault();
          });
        } else {
          if (response.totalCount > 1) dataResultDecoration.show();
          queryPerPage[currentPage] = paginatedQuery;
          response.currentPage = currentPage;
          response.prevPage = currentPage - 1;
          response.nextPage = currentPage + 1;
          let pagination = response.totalCount > 0 ? Math.ceil(response.totalCount / limitPagination) : 0;
          let pages = [];
          let i;
          for (i = 0; i < pagination; i++) {
            queryPerPage[i] = searchQuery + ' and limit ' + limitPagination + ' offset ' + (limitPagination * i);
            pages.push({'query': i, 'page': (i + 1)});
          }
          response.pages = pages;
          response.pageCount = pagination;
          response.prevPageQuery = jQuery.type(queryPerPage[response.prevPage]) === "undefined" ? null : queryPerPage[response.prevPage];

          let renderData = $(template.render(response));
          resultsContainer.html(renderData);

          resultsContainer.find('.page, .nextPage, .prevPage').on('click', function (e) {
            currentPage = $(this).data('page');
            loadSearchBlockContents();
            e.preventDefault();
          });
        }
      });
    };
    let resetSearchBlockContents = function () {
      form.find('input').each(function () {
        let input = $(this);
        if (input.attr('type') === 'checkbox' || input.attr('type') === 'radio') {
          input.prop('checked', false);
        } else {
          input.val('');
        }
      });
      form.trigger('submit');
    };

    resetSearchBlockContents();

  });
</script>
<style>
    @media (min-width: 576px) {
        #main-search-{/literal}{$block.id}{literal}-map {
            height: {/literal}{if $block.custom_attributes.limite}{$block.custom_attributes.limite|mul(140)}{else}800{/if}{literal}px !important;
        }
    }
</style>
{/literal}
{ezscript_require(array('leaflet/leaflet.0.7.2.js','leaflet/leaflet.markercluster.js'))}
