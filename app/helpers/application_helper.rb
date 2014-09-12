module ApplicationHelper
  def user_path user
    "#{ENV['MEURIO_HOST']}/users/#{user.id}"
  end

  def default_meta_tags
    {
      title: "Compartilhaço",
      description: "Amplie a visibilidade de uma mobilização ou causa a partir do compartilhamento sincronizado em perfis no Facebook e Twitter. Crie agora o seu Compartilhaço e Impacte milhares de pessoas através da ação coletiva na rede.",
      og: {
        title: "Compartilhaço",
        description: "Amplie a visibilidade de uma mobilização ou causa a partir do compartilhamento sincronizado em perfis no Facebook e Twitter. Crie agora o seu Compartilhaço e Impacte milhares de pessoas através da ação coletiva na rede.",
        url: root_url,
        image: image_url("compartilhaco-logo-hd.png")
      },
      twitter: {
        card: "summary",
        title: "Compartilhaço",
        description: "Amplie a visibilidade de uma mobilização ou causa a partir do compartilhamento sincronizado em perfis no Facebook e Twitter. Crie agora o seu Compartilhaço e Impacte milhares de pessoas através da ação coletiva na rede.",
        image: image_url("compartilhaco-logo-128.png"),
        url: root_url,
        site: "@meu_rio"
      }
    }
  end

  def facebook_form_button_class
    return "active" if facebook_form?
  end

  def twitter_form_button_class
    return "active" if twitter_form?
  end

  def facebook_form?
    params[:form] != "twitter"
  end

  def twitter_form?
    params[:form] == "twitter"
  end

  def campaign_highlight_class campaign
    return "succeeded" if campaign.succeeded?
    return "unsucceeded" if campaign.unsucceeded?
    return "archived" if campaign.archived?
  end
end
