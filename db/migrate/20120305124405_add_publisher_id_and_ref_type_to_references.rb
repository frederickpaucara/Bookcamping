class AddPublisherIdAndRefTypeToReferences < ActiveRecord::Migration
  def change
    add_column :references, :publisher_id, :integer
    add_column :references, :ref_type, :string, limit: 16
    remove_column :references, :like_it_marks
    remove_column :references, :read_later_marks
    remove_column :references, :glasslevel
    remove_column :references, :license
    remove_column :references, :book_list_id

    PaperTrail.enabled = false
    ActiveRecord::Base.record_timestamps = false

    types = [:Book, :Video, :Audio]
    Reference.all.each do |reference|
       ref_type = types[reference.camp_id - 1]
       reference.update_attribute(:ref_type, ref_type)
    end
  end
end
