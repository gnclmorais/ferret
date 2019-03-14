module ApplicationHelper
  def display_custom_meta_tags(options = {})
    display_meta_tags options.reverse_merge(
      title: page_title,
      site: Rails.configuration.x.application_name, # site title
      description: Rails.configuration.x.application_description, # page description
      keywords: 'tv shows, tv series, new york, london', #page keywords
      # charset: , # page character set
      # separator: , # text used to separate website name from page title
      image_src: asset_path('cover.jpg'),
      og: {
        title: :title,
        site_name: :site,
        description: :description,
        image: :image_src,
      }
      # twitter: , # add Twitter tags (Hash)
    )
  end

  def page_title
    content_for(:title) if content_for?(:title)

    # return Rails.configuration.x.application_name unless content_for?(:title)

    # [content_for(:title), Rails.configuration.x.application_name].join(" | ")
  end

  # TODO: Change pages into *pages
  def breadcrumbs(pages)
    klass = ->(total, index) {
      total == index ? 'is-active' : 'u-underline-on-hover is-hidden-mobile'
    }

    max_index = pages.length - 1

    pages.map.with_index do |(page, link), index|
      content_tag('li', class: klass.call(max_index, index)) do
        link_to(page, link)
      end
    end.join('').html_safe
  end
end
