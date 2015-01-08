ActiveAdmin.register Report do

  index do
    column :id
    column :name
    column :date_from
    column :date_to
    column do |resource|
      links = link_to I18n.t('active_admin.view'), resource_path(resource), :class => "member_link view_link"
      links += link_to I18n.t('active_admin.edit'), edit_resource_path(resource), :class => "member_link edit_link"
      links += link_to I18n.t('active_admin.delete'), resource_path(resource),
        :method => :delete, :class => "member_link delete_link", :confirm => "Are you sure?"
      links += link_to 'Download CSV', download_admin_report_path(resource), :class => "member_link view_link"
      links
    end
  end

  show do
    panel "Report Details" do
      attributes_table_for resource do
        row :id
        row :name
        row :date_from
        row :date_to
        row 'Download' do
          link_to "CSV", download_admin_report_path(resource)
        end
      end
    end
  end

  member_action :download, :method => :get do
    report = resource.export_data
    report_csv = CSV.generate do |csv|
      # header row
      csv << resource.class.export_headers
      report.each do |line|
        csv << line
      end
    end
    send_data(report_csv, :type => 'text/csv', :filename => resource.export_filename)
  end


end
