# -*- coding: utf-8 -*-
class CreateOktopartialTables < ActiveRecord::Migration
  def self.up
    create_table :oktopartial_publications do |t|
      t.string :source_path, :limit => 255, :null => false # アップロードされたファイルのパス
      t.string :dirname, :limit => 255, :null => false # 公開対象ディレクトリ
      t.time   :published_at, :null => false # 公開日時
      t.string :status_cd, :limit => 1, :default => '0', :null => false # ステータスコード(0:公開準備中, 1:公開準備エラー, 2:公開待ち, 3:公開中, 4:公開済み, 5:公開エラー)
      t.text   :error_messages # エラーメッセージ
      t.timestamps
    end
    add_index(:oktopartial_publications, [:status_cd, :published_at])

    create_table :oktopartial_contents do |t|
      t.string :method_name, :limit => 6
      t.string :path
      t.string :static_cd, :limit => 2
      t.string :view_cd  , :limit => 2
      t.string :action_cd, :limit => 2

      t.timestamps
    end
    add_index(:oktopartial_contents, :path)
  end

  def self.down
    drop_table :oktopartial_publications
    drop_table :oktopartial_contents
  end
end
