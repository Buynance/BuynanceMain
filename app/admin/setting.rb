ActiveAdmin.register_page "Setting" do
  content do
    table :class => 'setting' do
      thead do
        th 'Setting'
        th 'Value'
        th ''
      end
      Setting.all.each do |key, val|
        tr do
          td strong key
          td val
          td do
            link_to "delete", admin_setting_delete_path( :key => key ), :method => :post
          end
        end
      end
      tr do
        form :action => admin_setting_create_path, :method => :post do
          td do
            input :name => 'key'
          end
          td do
            input :name => 'val'
          end
          td do
            input :type => 'submit', :value => 'Add'
          end
        end
      end
    end
  end

  page_action :create, :method => :post do
    Setting[params[:key]] = params[:val]
    redirect_to :back, :notice => "#{params[:key]} added"
  end

  page_action :delete, :method => :post do
    Setting.destroy params[:key]
    redirect_to :back, :notice => "#{params[:key]} deleted"
  end
end