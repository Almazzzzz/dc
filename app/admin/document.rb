ActiveAdmin.register Document do

	permit_params :uri, :title, :body

	menu priority: 9

	controller do
    defaults finder: :find_by_uri
  end

	index do
		selectable_column
		id_column
		column 'URI', :uri
		column 'Title', sortable: :title do |document|
			truncate(document.title, length: 50, separator: ' ')
		end		
		column 'Body', sortable: :body do |document|
			truncate(document.body, length: 50, separator: ' ')
		end
		column :created_at
		actions
	end

	filter :uri
	filter :title
	filter :body
	filter :created_at

end
