module ApplicationHelper
  def page_title
    return Rails.configuration.x.application_name unless content_for?(:title)

    [content_for(:title), Rails.configuration.x.application_name].join(" | ")
  end

  # TODO: Change pages into *pages
  def breadcrumbs(pages)
    klass = ->(total, index) { 'is-active white' if total == index }

    max_index = pages.length - 1

    pages.map.with_index do |(page, link), index|
      content_tag('li', class: klass.call(max_index, index)) do
        link_to(page, link)
      end
    end.join('').html_safe
  end
end
