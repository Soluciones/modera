# Methods added to this helper will be available to all templates in all the applications.
module EmergiaHelper

  # Devuelve TRUE si el usuario ha hecho login con el nivel de permisos correspondiente o superior, o FALSE si no
  def soy_admin?
    soy_tipos_usuario?([Usuario::ESTADO_ADMIN, Usuario::ESTADO_GESTOR_USR, Usuario::ESTADO_SUPERADMIN])
  end
  def soy_gestor_usr?
    soy_tipos_usuario?([Usuario::ESTADO_GESTOR_USR, Usuario::ESTADO_SUPERADMIN])
  end
  def soy_moderador?
    soy_tipos_usuario?([Usuario::ESTADO_MODERADOR, Usuario::ESTADO_ADMIN, Usuario::ESTADO_GESTOR_USR, Usuario::ESTADO_SUPERADMIN])
  end
  def soy_superadmin?
    soy_tipos_usuario?([Usuario::ESTADO_SUPERADMIN])
  end

  # Devuelve TRUE si el usuario ha hecho login y su estado es el que se pasa como parámetro
  def soy_tipos_usuario?(estados)
    permiso = @yo and estados.include?@yo.estado_id
  end

  def ths(cols, url_base='', opciones={})
    result = opciones[:sin_tr] ? "" : "<tr class=\"#{opciones[:clase] ? opciones[:clase] : 'cabecera_roja'}\">"
    indice = 0
    cols.each do |col|
      txt = (col==col.downcase) ? col.humanize : col.gsub('_', ' ')
      if !url_base.blank?
        # Calcula la URL de destino
        arr_params = opciones[:otros_params] ? Array.new(opciones[:otros_params]) : Array.new     # Coge el array de otros params, si procede
        arr_params << "orden=#{opciones[:ordenadores] ? opciones[:ordenadores][indice] : col.to_s.quita_acentos.downcase}" if (opciones[:default] != col.quita_acentos.downcase  and !opciones[:ordenadores]) or (opciones[:ordenadores] and (opciones[:default] != opciones[:ordenadores][indice])) # Añade el parámetro orden (sin acento), salvo que sea la opción por defecto
        url = (opciones[:nolink] and opciones[:nolink].include?(col)) ? '#' : "#{url_base}#{('?' + arr_params.join('&'))  if arr_params.length > 0}"
        title = opciones[:titles] ? opciones[:titles][indice].humanize : nil
        txt = txt == '-' ? '' : link_to_unless(request.fullpath == url, txt, url, style: (url=='#') ? 'text-decoration:none;' : nil, title: title)
        # -- Esto debería funcionar... pero nunca le parece el current, aunque lo sea, si la URL tiene ampersand: /usuarios/admin-list?estado=5&orden=nick.
        # -- el problema es que link_to_unless_current utiliza current_page?, que no se porqué hace una escapeHTML a la URL que le pasas
      end

      # Calcula el estilo de la columna: centrado, ancho...
      estilo = ''
      estilo += 'text-align:center;' if opciones[:center] and opciones[:center].include?(col)
      estilo += "width:#{opciones[:anchos][cols.index(col)]}px;" if opciones[:anchos] and !opciones[:anchos][cols.index(col)].blank?
      estilo += " #{opciones[:estilos][indice]}" if opciones[:estilos]
      estilo = " style=\"#{estilo}\"" if !estilo.blank?

      clase = (indice == 0) ? " class = \"primero\"" : (indice == cols.length-1) ? " class = \"ultimo\"" : '' unless opciones[:sin_clase]

      result += "<th#{estilo}#{clase}>#{txt=='-' ? '' : txt.sub('Num ', 'Nº ')}</th>"
      indice += 1
    end
    raw(opciones[:sin_tr] ? result : result +="</tr>")
  end

  def campo(form, nombre, opciones={})
    opciones = {tipo: 'text'}.merge opciones
    # Separa las opciones recibidas en el hash "opciones", de uso interno, y los hash "options" y "html_options", que van directos al objeto.
    html_options = {}
    %w(maxlength class style rows cols disabled onfocus onblur onkeyup onkeydown onchange tabindex placeholder autofocus required pattern value).each do |attrb|
      if opciones.has_key?(attrb.to_sym)
        html_options[attrb.to_sym] = opciones.delete(attrb.to_sym)
      end
    end
    options = {}
    %w(start_year end_year discard_day).each do |attrb|
      if opciones.has_key?(attrb.to_sym)
        options[attrb.to_sym] = opciones.delete(attrb.to_sym)
      end
    end

    if ['&nbsp;', '-'].include?(opciones[:label])
      texto_label = '&nbsp;'.html_safe
    else
      texto_label = opciones[:label].o_si_no(nombre.humanize).html_safe
      texto_label += ':' unless opciones[:label_pos] == 'detras'
    end
    campo = nombre = nombre.quita_acentos
    nuestro_label = (opciones[:tipo] == 'especial' ? texto_label : form.label(campo, texto_label)) if opciones[:tipo]!='hidden'
    nuestro_label += render_2_string('comparador/info_y_globo_informativo', campo: nombre, texto: opciones[:globo_info][:texto]) if opciones[:globo_info]

    prefijo = opciones[:prefijo]
    opciones[:estilo] = 'masinfo' if !opciones[:estilo] && opciones[:campo_info]
    if opciones[:estilo] or (opciones[:tipo] == 'especial')
      div_tag_th= "<div id=\"#{nombre}_th\" style=\"#{opciones[:estilo]}\" >"
      div_tag_td= "<div id=\"#{nombre}_td\" style=\"display:block;#{opciones[:estilo]}\" >"
      div_tag_close = '</div>'
    end
    sufijo = opciones[:sufijo] if opciones[:tipo]!='hidden'
    texto_si = opciones[:texto_si] || 'Sí'
    texto_no = opciones[:texto_no] || 'No'

    # Por el momento voy a intentar ahorrarme poner en estos tr el tr_id y el tr_style por los problemas de duplicidad de id
    # con el tiempo si es necesario se verá en un caso "real", que ahora no tengo para comprobar
    fila_sig = "<tr><td colspan=""2"">#{opciones[:fila_sig]}</td></tr>" if !opciones[:fila_sig].blank?
    fila_ant = "<tr><td colspan=""2"">#{opciones[:fila_ant]}</td></tr>" if !opciones[:fila_ant].blank?

    campo = case opciones[:tipo]
      when 'text' then form.text_field(nombre, html_options)
      when 'email' then form.email_field(nombre, html_options)
      when 'tel' then form.telephone_field(nombre, { pattern: '(6|7|8|9)(\d\s*){8}' }.merge(html_options))
      when 'cod_postal' then form.text_field(nombre, { pattern: '\d{4,5}', maxlength: Usuario::LONG_MAX_CP }.merge(html_options))
      when 'hidden' then form.hidden_field(nombre, html_options)
      when 'file' then form.file_field(nombre, html_options)
      when 'area' then form.text_area(nombre, html_options)
      when 'password' then form.password_field(nombre, html_options.merge({maxlength: Usuario::LONG_MAX_PASSWORD, size: Usuario::TALLA_CAJA_PASSWORD}))
      when 'label' then form.text_field(nombre, html_options.merge({disabled: 'disabled'}))
      when 'datetime' then form.datetime_select(nombre, html_options)
      when 'time' then form.time_select(nombre, html_options)
      when 'date' then form.date_select(nombre, options, html_options)
      when 'dropdown' then campo_dropdown(form, nombre, opciones, html_options)
      when 'dropdowntext' then form.collection_select(nombre, opciones[:datos], :nombre, :nombre, prompt: opciones[:prompt])
    end
    # Recibe un array [['dato1', 0], ['dato2', 1]], Puede generarse con ['dato1', 'dato2'].pon_indice
    if opciones[:tipo]=='dropdownoptions'
      opt = {}
      opt = opt.merge(prompt: opciones[:prompt]) if opciones[:prompt]
      opt = opt.merge(selected: opciones[:selected]) if opciones[:selected]
      campo = form.select(nombre, opciones[:datos], opt, html_options)
    end
    campo = form.check_box(nombre, {class: 'check'}.merge!(html_options)) if opciones[:tipo]=='checkbox'
    campo = "#{texto_si}#{form.radio_button(nombre, true, class: 'check')} &nbsp; #{texto_no}#{form.radio_button(nombre, false, class: 'check')}" if opciones[:tipo]=='radiobutton'
    if opciones[:tipo]=='multi-radiobutton'
      campo = ''
      opciones[:opciones].each do |opcion|
        if (!opciones[:onchange_inteligente])
          campo += " &nbsp; #{opcion}#{form.radio_button(nombre, opcion, {class: 'check'}.merge(html_options) )}"
        else
          campo += " &nbsp; #{opcion}#{form.radio_button(nombre, opcion, class: 'check', onchange: "#{multi_onchange(opcion)}")}"
        end
      end
    end
    if opciones[:tipo]=='multi-checkbox'
      campo = ''
      opciones[:opciones].each do |o|
        # opciones puede ser un array %w(banca cuentas) o un hash {fin_comprar_vivienda: 'Comprar vivienda', fin_cambiar_hipoteca: 'Cambiar de hipoteca'}
        clave = o.class == Array ? o[0] : o.to_s.quita_acentos
        valor = o.class == Array ? o[1] : o.to_s.humanize

        campo += form.check_box(clave, class: 'check')
        campo += form.label(clave, valor)
        campo += '&nbsp; &nbsp;'
      end
    end
    campo = opciones[:campo] if opciones[:tipo]=='especial'   # Si es un campo especial, ya me pasan el campo hecho del todo

    campo += raw('&nbsp; <span class="mas_info">Más información:</span> ' + form.text_field(opciones[:mas_info], class: 'medio')) if opciones[:mas_info]
    if opciones[:campo_info]
      nuestro_label = "#{campo}#{nuestro_label}"
      campo = raw('&nbsp; ' + form.label("#{nombre}_info", "Más información:") + form.text_field("#{nombre}_info", html_options))
      campo = raw('&nbsp; ' + form.label("#{nombre}_nombre", "Nombre:", class: 'nombre_campo_info') + form.text_field("#{nombre}_nombre", html_options) + campo) if opciones[:campo_nombre]
    elsif opciones[:con_checkbox_fake]
      nuestro_label = "#{form.check_box("#{nombre}_fake", {class: 'check'})}#{nuestro_label}"
    end

    tr_id = opciones[:tr_id] ? " id=\"#{opciones[:tr_id]}\"" : nil
    tr_style = opciones[:tr_style] ? " style=\"#{opciones[:tr_style]}\"" : nil

    if opciones[:inline]
      raw "<th>#{div_tag_th} #{nuestro_label} #{div_tag_close}</th> <td>#{div_tag_td} #{prefijo} #{campo} #{sufijo} #{div_tag_close} </td>"
    elsif opciones[:label_pos] == 'detras'
      raw "#{fila_ant} <tr#{tr_id}#{tr_style}> <td colspan=\"2\">#{div_tag_td} #{campo} #{nuestro_label} #{div_tag_close} </td> </tr> #{fila_sig}"
    elsif opciones[:label_pos] == 'arriba'
      raw "<div class=\"como-p\"> <div>#{nuestro_label}</div> #{div_tag_td} #{prefijo} #{campo} #{sufijo} #{div_tag_close} </div> #{fila_sig}"
    elsif opciones[:label_pos] == 'inline'
      raw "<div class=\"como-p\"> #{nuestro_label} #{prefijo} #{campo} #{sufijo}  </div> #{fila_sig}"
    elsif opciones[:colspan]
      salida = "<td#{" colspan=\"#{opciones[:colspan]}\"" if opciones[:colspan] != 1}>"
      salida += "<div#{" style=\"float:left; margin:4px 5px 0 0;\"" if opciones[:tipo]!='area'}> #{nuestro_label} </div>" if (opciones[:label] != "&nbsp;")
      salida += " #{div_tag_td} #{campo} #{sufijo} #{div_tag_close} </td>"
      raw salida
    else
      raw "#{fila_ant} <tr#{tr_id}#{tr_style}> <th>#{div_tag_th} #{nuestro_label} #{div_tag_close}</th> <td>#{div_tag_td} #{prefijo} #{campo} #{sufijo} #{div_tag_close} </td> </tr> #{fila_sig}"
    end
  end

  # Recibe un array de objetos con objeto.id y objeto.nombre
  def campo_dropdown(form, nombre, opciones, html_options)
    hash_select = { prompt: opciones[:prompt], include_blank: opciones[:include_blank] }
    hash_select = hash_select.merge(selected: opciones[:selected]) if opciones[:selected]  # Necesario si el id no es de tipo numérico, habrá que hacerle "to_i"
    if opciones[:agrupar_por]
      form.grouped_collection_select(nombre, opciones[:agrupar_por], opciones[:datos], :nombre, :id, :nombre, opciones, html_options)
    else
      form.collection_select(nombre, opciones[:datos], :id, :nombre, hash_select, html_options )
    end
  end

  # Sustituye al link_to image_tag(iii, :alt => xxx), yyy, :title => xxx
  def link_title_img(img, txt, url, opciones = {})
    link_to(image_tag(img, alt: txt), url, {title: txt}.merge(opciones))
  end

end
