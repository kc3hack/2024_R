require 'net/http'
require 'uri'

class ShopsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :search]

  def index
    @shops = [] # エラーへの対処用
  end

  def create
    lat = params[:lat].to_f # 緯度
    lon = params[:lon].to_f # 経度
    evaluation = params[:evaluation].to_f # 評価
    name = params[:name] # 店舗名
    address = params[:address] # 住所
    shop = Shop.find_by(user_id: current_user.id, address: address) # 住所に紐付いたユーザ情報があればデータ取得

    if !shop # 該当データに初めてアクセスする時(保存されてなかった時)
      shop = Shop.new(user_id: current_user.id, latitude: lat, longitude: lon, name: name, evaluation: evaluation, address: address)
      shop.save # 次回以降の詳細画面アクセス用にShopレコードとして保存する
    end
    redirect_to shop_path(shop)
  end

  def show
    @shop = Shop.find(params[:id])

    if @shop.user != current_user # 別のユーザの登録情報だったら弾く
      redirect_to root_path
      return
    end
  end

  def favorite
    @shop = Shop.find(params[:id])

    if @shop.user != current_user # 別のユーザの登録情報だったら弾く
      redirect_to root_path
      return
    end
    
    flag = @shop.is_favorite # 現在のお気に入り状況
    @shop.update(is_favorite: !flag) # を反転させる
    redirect_to shop_path(@shop)
  end

  def search

    #テキストで検索するエンドポイント
    url = URI.parse('https://places.googleapis.com/v1/places:searchText')
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    #検索するためのデータを入力
    searchData = {
      "textQuery": params[:genre],
      "languageCode": "ja",
      "locationBias": {
        "circle": {
          "center": {
            "latitude": 34.65112098708317,
            "longitude": 135.58856512184337,
          },
          "radius": 200.0,
        }
      },
      "openNow": true
    }

    #必須パラメーター 取得するデータも制限
    headers = {
      'Content-Type' => 'application/json',
      'X-Goog-Api-Key' => ENV["GOOGLE_PLACE_API_KEY"],
      'X-Goog-FieldMask' => 'places.displayName,places.formattedAddress,places.rating,places.location'
    }

  request = Net::HTTP::Post.new(url.path, headers)
  request.body = searchData.to_json
  response = http.request(request)

  
  if response.code.to_i == 200
    result = JSON.parse(response.body)
    @shops = result["places"].sort_by{|place| place["rating"] || 0 }.reverse
    render :index
  else
    puts "API request failed with status #{response.code}"
    redirect_to root_path
  end

  end

  def patrol
    @favorite_shops = Shop.where(user_id: current_user.id, is_favorite: true)
    @via_array = [] # エラー回避用
  end

  def route
    #via1~8で経路は持って来れると思われる
    #名前からモデルを見つけてそれの緯度経度を使って中間点を設定しマップを表示させたい
    via_params = [params[:via1],params[:via2],params[:via3],params[:via4],params[:via5],params[:via6],params[:via7],params[:via8]]

    # 指定された店の名前のみ抽出
    selected_name_array = []
    via_params.each do |v|
      if v != ""
        selected_name_array.push(v)
      end
    end

    # 指定された店のレコードを取得
    @via_array = []
    selected_name_array.each do |n|
      @via_array.push(Shop.find_by(name: n))
    end

    @favorite_shops = Shop.where(user_id: current_user.id, is_favorite: true)
    render :patrol, status: 303
    #redirect_to shops_patrol_path(array: @via_array)
    #redirect_to action: :patrol, params:{'array'  => @via_array}
  end



end
