module ApplicationHelper
	def full_title(page_title)
		base_title="ROR Sample App"
		if page_title.empty?
			return base_title
		end
		return "#{base_title} | #{page_title}"
	end
end
