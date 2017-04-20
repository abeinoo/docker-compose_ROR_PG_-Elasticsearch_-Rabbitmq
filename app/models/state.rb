class State < ApplicationRecord
    belongs_to :bug, optional: true
end
