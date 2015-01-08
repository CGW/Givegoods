module FormHelper
  def autotabindex
    @current_tab_index ||= 0
    @current_tab_index += 1
  end
end
