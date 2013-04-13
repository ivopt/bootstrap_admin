module BootstrapAdmin::PaginatorHelper

  # =============================================================================
  def render_paginator(paginator)
    render "paginator", :paginator => paginator
  end

  # =============================================================================
  def render_searchbox
    render "search_box"
  end

  # =============================================================================
  def paginator_previous(paginator)
    if paginator[:current_page] == 1
      url       = "#"
      css_class = "prev disabled"
    else
      url       = url_for(params.merge(:page => paginator[:current_page]-1))
      css_class = "prev"
    end

    content_tag(:li, :class=>css_class) do
      if "#" == url
        content_tag(:span, "&larr; #{t(:Previous)}".html_safe)
      else
        link_to "&larr; #{t(:Previous)}".html_safe, url
      end
    end.html_safe
  end

  # =============================================================================
  def paginator_next(paginator)
    if paginator[:current_page] == paginator[:pages]
      url       = "#"
      css_class = "next disabled"
    else
      url       = url_for(params.merge(:page => paginator[:current_page]+1))
      css_class = "next"
    end

    content_tag(:li, :class=>css_class) do
      if "#" == url
        content_tag(:span, "#{t(:Next)} &rarr;".html_safe)
      else
        link_to "#{t(:Next)} &rarr;".html_safe, url
      end
    end.html_safe
  end

  # =============================================================================
  def paginator_pages(paginator)
    if paginator[:pages] <= 5
      [
        paginator_range(paginator[:current_page], 1..paginator[:pages])
      ]

    elsif paginator[:current_page] <= 3
      [
        paginator_range(paginator[:current_page], 1..4),
        paginator_page("...", "disabled"),
        paginator_page(paginator[:pages])
      ]

    elsif paginator[:current_page] >= paginator[:pages] - 2
      [
        paginator_page(1),
        paginator_page("...", "disabled"),
        paginator_range(paginator[:current_page], (paginator[:pages]-3)..paginator[:pages])
      ]

    else
      [
        paginator_page(1),
        paginator_page("...", "disabled"),
        paginator_range(paginator[:current_page], (paginator[:current_page]-1)..(paginator[:current_page]+1)),
        paginator_page("...", "disabled"),
        paginator_page(paginator[:pages])
      ]
    end.join.html_safe
  end

  # =============================================================================
  def paginator_range(current_page, range)
    contents = range.map do |page|
      content_tag(:li, :class => (page==current_page ? "active" : "")) do
        if page==current_page
          content_tag(:span, page)
        else
          link_to page, url_for(params.merge(:page => page))
        end
      end
    end

    contents.join.html_safe
  end

  # =============================================================================
  def paginator_page(num, css_class = nil)
    if num.to_i > 0
      url = url_for(params.merge :page => num)
    else
      url = "#"
    end

    content_tag(:li, :class=>css_class) do
      if '#' == url
        content_tag(:span, num)
      else
        link_to num, url
      end
    end.html_safe
  end

end # module BootstrapAdmin::PaginatorHelper
