class ConstituencySerializer < ActiveModel::Serializer
  attributes :constituency_id, :valid_votes, :constituency_name, :voters, :constituency_type, :sub_region,
             :turnout_percentage, :candidate_count, :district_name
end
