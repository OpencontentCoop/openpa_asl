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
      data-classes="{$block.custom_attributes.includi_classi|wash()}"
      data-limit="{$block.custom_attributes.limite|wash()}">
    <div class="d-block d-lg-none d-xl-none text-center">
        <a href="#filtersCollapse" role="button" class="btn btn-default btn-md text-uppercase collapsed" data-bs-toggle="collapse" aria-expanded="false" aria-controls="filtersCollapse">{'Filters'|i18n('bootstrapitalia')}</a>
    </div>

    <section class="bg-light border-top py-5">
        <div class="container">
            <div class="row">
                <div class="col-lg-3 d-lg-flex d-xl-flex collapse" id="filtersCollapse">
                    <div class="col-12">
                        <div class="row">
                        {foreach $attributes as $attribute}
                            {if $attribute.identifier|eq('topics')}
                                {def $topics_tree = topics_tree()}
                                <div class="col-6 col-lg-12 mb-2">
                                    <h6 class="text-uppercase mb-2">{$attribute.name|wash()}</h6>
                                    <div class="mb-3">
                                        {foreach $topics_tree as $item}
                                            <div class="form-check custom-control custom-checkbox mb-1"
                                                 style="display:none"
                                                 data-filter="{$item.contentobject_id}">
                                                <input name="{$attribute.identifier}.id"
                                                       id="{$attribute.identifier}-{$item.contentobject_id}"
                                                       value="{$item.contentobject_id}"
                                                       class="custom-control-input"
                                                       type="checkbox">
                                                <label class="custom-control-label m-0 fs-6"
                                                       for="{$attribute.identifier}-{$item.contentobject_id}">
                                                    {$item.name|wash()}
                                                </label>
                                            </div>
                                        {/foreach}
                                    </div>
                                </div>
                                {undef $topics_tree}

                            {else}
                                {def $items_count = 80
                                     $parent_node_id = cond(is_set($attribute.root_node), $attribute.root_node, 1)
                                     $sort_array = array('name', true())}
                                {if $parent_node_id|ne(1)}
                                    {set $sort_array = fetch(content, node, hash(node_id, $parent_node_id)).sort_array}
                                {/if}
                                {set $items_count = fetch(content, concat($attribute.fetch_function, '_count'), hash('parent_node_id', $parent_node_id, 'class_filter_type', 'include', 'class_filter_array', $attribute.class_constraint_list))}
                                {if $items_count|gt(0)}
                                    <div class="col-6 col-lg-12 mb-2">
                                        <h6 class="text-uppercase mb-2">{$attribute.name|wash()}</h6>
                                        <div class="mb-3">
                                            {def $items = fetch(content, $attribute.fetch_function, hash('parent_node_id', $parent_node_id, 'class_filter_type', 'include', 'class_filter_array', $attribute.class_constraint_list, 'sort_by', $sort_array))}
                                            {foreach $items as $item}
                                                <div class="form-check custom-control custom-checkbox mb-1"
                                                     style="display:none"
                                                     data-filter="{$item.contentobject_id}">
                                                    <input name="{$attribute.identifier}.id"
                                                           id="{$attribute.identifier}-{$item.contentobject_id}"
                                                           value="{$item.contentobject_id}"
                                                           class="custom-control-input"
                                                           type="checkbox">
                                                    <label class="custom-control-label fs-6 m-0"
                                                           for="{$attribute.identifier}-{$item.contentobject_id}">
                                                        {$item.name|wash()}
                                                    </label>
                                                </div>
                                            {/foreach}
                                            {undef $items}
                                        </div>
                                    </div>
                                {/if}
                                {undef $items_count $parent_node_id $sort_array}
                            {/if}
                        {/foreach}
                        </div>
                    </div>
                </div>
                <div class="col-lg-9 pr-0">
                    <div class="sorters row">
                        <div class="col-12 pb-4">
                            {if $block.custom_attributes.input_search_placeholder|ne('')}
                            <h2 class="h5">{$block.custom_attributes.input_search_placeholder|wash()}</h2>
                            {/if}
                            <div class="cmp-input-search">
                                <div class="form-group">
                                    <div class="input-group">
                                        <label for="{$block.id}-search" class="visually-hidden">{'Search'|i18n('design/plain/layout')}</label>
                                        <input type="search" class="autocomplete form-control" id="{$block.id}-search" name="q" data-bs-autocomplete="[]" data-focus-mouse="false">

                                        <div class="input-group-append">
                                            <button class="btn btn-primary" type="submit" id="button-3">{'Search'|i18n('design/plain/layout')}</button>
                                        </div>

                                        <span class="autocomplete-icon" aria-hidden="true">
                                            {display_icon('it-search', 'svg', 'icon icon-sm icon-primary', 'Search'|i18n('design/plain/layout'))}
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-3" data-result_decoration  style="display:none">
                            <div class="bootstrap-select-wrapper lh-lg">
                                <span class="font-weight-bold" data-count></span> {'contents found'|i18n('bootstrapitalia')}
                            </div>
                        </div>
                        <div class="col-9 text-end" data-result_decoration  style="display:none">
                            <label class="me-1">{'Sorting by'|i18n('openpa/search')}</label>
                            <select data-param="sort" class="rounded">
                                <option selected="selected" value="published">{'Publication date'|i18n('openpa/search')}</option>
                                <option value="name">{'Name'|i18n('openpa/search')}</option>
                            </select>
                            <label class="d-none">Direction</label>
                            <select data-param="direction" class="rounded">
                                <option selected="selected" value="desc">Z-A</option>
                                <option value="asc">A-Z</option>
                            </select>
                        </div>
                    </div>
                    <div class="py-4 results"></div>
                </div>
            </div>
        </div>
    </section>
</form>

{ezscript_require(array('jsrender.js'))}

{literal}
    <script id="tpl-results" type="text/x-jsrender">
	<div class="card-wrapper card-teaser-wrapper card-teaser-wrapper-equal card-teaser-block-2">
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
                        {{for pages ~current=currentPage}}
                            <li class="page-item"><a href="#" class="page-link page" data-page_number="{{:page}}" data-page="{{:query}}"{{if ~current == query}} data-current aria-current="page"{{/if}}>{{:page}}</a></li>
                        {{/for}}
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
<div class="col-xs-12 spinner text-center">
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
    let form = $('{/literal}#main-search-{$block.id}{literal}');
    let classes = form.data('classes').split(',');
    let currentPage = 0;
    let queryPerPage = [];
    let limitPagination = form.data('limit') || 12;
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
          view: 'card_teaser'
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
    let isFiltersBuilt = false;

    form.find('[data-param], input[type="checkbox"], input[type="radio"]').on('change', function () {
      form.trigger('submit');
    });

    form.on('submit', function (e) {
      let formSerializeArray = $(this).serializeArray();
      let d = {};
      $.each(formSerializeArray, function () {
        if (this.value.length > 0) {
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
      loadSearchBlockContents();

      e.preventDefault();
    });

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
{/literal}

