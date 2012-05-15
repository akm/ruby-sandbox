# -*- coding: utf-8 -*-
class CreateOktopartialPublications < ActiveRecord::Migration
  def self.up
    create_table :oktopartial_publications do |t|
      t.string :source_path, :limit => 255, :null => false # アップロードされたファイルのパス
      t.string :dirname, :limit => 255, :null => false # 公開対象ディレクトリ
      t.time   :published_at, :null => false # 公開日時
      t.string :status_cd, :limit => 1, :default => '0', :null => false # ステータスコード(0:公開準備中, 1:公開準備エラー, 2:公開待ち, 3:公開中, 4:公開済み, 5:公開エラー)
      t.text   :error_messages # エラーメッセージ
      t.timestamps
    end
  end

  def self.down
    drop_table :oktopartial_publications
  end
end
