defmodule BackerWeb.LayoutView do
  use BackerWeb, :view

  @exceptionpath "/admin"

    def activate(path, href) do
    	if path =~ href and href != @exceptionpath do
    		"active"
    	end
  end

end
