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
require 'spec_helper'

describe ArticleTemplatePolicy do
  include PunditMatcher

  subject { ArticleTemplatePolicy.new(user, article_template)   }
  let(:article_template) { FactoryGirl.create :article_template }
  let(:user) { nil }

  context "for a visitor" do
    it { should deny(:new)     }
    it { should deny(:create)  }
    it { should deny(:edit)    }
    it { should deny(:update)  }
    it { should deny(:destroy) }
  end

  context "for a random logged-in user" do
    let(:user) { FactoryGirl.create :user }
    it { should deny(:new)                }
    it { should deny(:create)             }
    it { should deny(:edit)               }
    it { should deny(:update)             }
    it { should deny(:destroy)            }
  end

  context "for the template owning user" do
    let(:user) { article_template.user }
    it { should permit(:new)           }
    it { should permit(:create)        }
    it { should permit(:edit)          }
    it { should permit(:update)        }
    it { should permit(:destroy)       }
  end
end
