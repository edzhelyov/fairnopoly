#
# Farinopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Farinopoly.
#
# Farinopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Farinopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Farinopoly.  If not, see <http://www.gnu.org/licenses/>.
#
module UsersHelper
  def user_resource
    @user
  end

  def active_articles
    resource.articles.where("state = ?", :active).page(params[:active_articles_page])
  end

  def inactive_articles
    resource.articles.where("state != ? AND state != ?", :active, :closed ).page(params[:inactive_articles_page])
  end

  # JS used in icheck checkboxes onclick to open a new window with the contents of a link
  # @param target [String] path
  # @return [String] JS code
  def on_click_open_link_in_label target
    "var e=arguments[0] || window.event;
      window.open('#{target}','_blank');
      e.cancelBubble = true;
      e.stopPropagation();
      return false;"
  end
end
