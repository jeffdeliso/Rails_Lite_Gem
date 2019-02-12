require 'active_support/concern'

module UrlHelpers
  extend ActiveSupport::Concern

  module ClassMethods

    def make_url_arr(pattern)
      pattern.inspect.delete('\^$?<>/+()')
          .split('\\').drop(1).reject { |el| el == "d"}
    end

    def make_url_arr_from_path(path)
      path.split("/").drop(1)
    end

    def make_url(pattern)
      "/" + make_url_arr(pattern).join("/")
    end

    def make_helpers(patterns)
      patterns.each do |pattern|
        url_arr = make_url_arr(pattern)
        if url_arr.include?("id") ||  url_arr.any? { |str| str.include?("_id") }
          make_id_helpers(url_arr)
        else
          make_idless_helpers(url_arr)
        end
      end
    end

    def make_helper_name(pattern)
      url_arr = make_url_arr(pattern)
      return "root_url" if url_arr.empty?

      if url_arr.include?("id") ||  url_arr.any? { |str| str.include?("_id") }
        make_id_helper_name(url_arr)
      else
        make_idless_helper_name(url_arr)
      end
    end
    
    def make_id_helper_name(url_arr)
      name_arr = url_arr.dup
      name_arr[0] = url_arr.first.singularize
      filtered_arr = name_arr.reject do |el| 
        el == "id" || el.include?("_id")
      end

      if filtered_arr.last == "edit" || filtered_arr.last == "new"
        filtered_arr.unshift(filtered_arr.pop) 
      end

      filtered_arr.join("_") + "_url"
    end

    def make_idless_helper_name(url_arr)
      url_arr = url_arr.dup
       if url_arr.last == "edit" || url_arr.last == "new"
        url_arr.unshift(url_arr.pop) 
      end

      url_arr.join("_") + "_url"
    end

    private

    def make_idless_helpers(url_arr)
      helper_name = make_idless_helper_name(url_arr)
      url = "/" + url_arr.join("/")

      define_method(helper_name) do
        url
      end
    end

    def make_id_helpers(url_arr)
      helper_name = make_id_helper_name(url_arr)
      
      define_method(helper_name) do |*ids|
        url = url_arr.map do |el|
          if el == "id" || el.include?("_id")
            id = ids.pop
            obj_id = id.try(:id)

            "#{obj_id || id}"
          else
            el
          end
        end
          
        "/" + url.join("/")
      end
    end
  end
end
