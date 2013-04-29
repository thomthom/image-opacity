#-------------------------------------------------------------------------------
#
# Thomas Thomassen
# thomas[at]thomthom[dot]net
#
#-------------------------------------------------------------------------------

require 'sketchup.rb'
begin
  require 'TT_Lib2/core.rb'
rescue LoadError => e
  module TT
    if @lib2_update.nil?
      url = 'http://www.thomthom.net/software/sketchup/tt_lib2/errors/not-installed'
      options = {
        :dialog_title => 'TT_Lib² Not Installed',
        :scrollable => false, :resizable => false, :left => 200, :top => 200
      }
      w = UI::WebDialog.new( options )
      w.set_size( 500, 300 )
      w.set_url( "#{url}?plugin=#{File.basename( __FILE__ )}" )
      w.show
      @lib2_update = w
    end
  end
end


#-------------------------------------------------------------------------------

if defined?( TT::Lib ) && TT::Lib.compatible?( '2.7.0', 'Image Opacity' )

module TT::Plugins::ImageOpacity  
  
  ### MENU & TOOLBARS ### ------------------------------------------------------
  
  # Context menu
  UI.add_context_menu_handler { |context_menu|
    model = Sketchup.active_model
    sel = model.selection
    
    if sel.length == 1 && sel.first.is_a?(Sketchup::Image)
      menu = context_menu.add_submenu('Opacity')
      (0..100).step(10) { |i|
        menu.add_item("#{i}%") { self.set_image_opacity(i) }
      }
      menu.add_separator
      menu.add_item('Custom') {
        
        result = UI.inputbox(
          ['Percent Opacity: '],
          [self.get_image_opacity],
          'Set Image Opacity'
        )
        if result
          opacity = result[0]
          opacity = 0 if opacity < 0
          opacity = 100 if opacity > 100
          self.set_image_opacity(opacity)
        end
      }
    end
  }
  
  
  ### MAIN SCRIPT ### ----------------------------------------------------------
  
  
  # @since 1.0.0
  def self.set_image_opacity(opacity = 0)
    image = Sketchup.active_model.selection.first
    material = TT::Image.material( image )
    material.alpha = opacity / 100.0
  end
  
  
  # @since 1.0.0
  def self.get_image_opacity
    image = Sketchup.active_model.selection.first
    material = TT::Image.material( image )
    material.alpha * 100.0
  end
  
  
  ### DEBUG ### ----------------------------------------------------------------
  
  # @note Debug method to reload the plugin.
  #
  # @example
  #   TT::Plugins::SuperGlue.reload
  #
  # @param [Boolean] tt_lib Reloads TT_Lib2 if +true+.
  #
  # @return [Integer] Number of files reloaded.
  # @since 1.0.0
  def self.reload( tt_lib = false )
    original_verbose = $VERBOSE
    $VERBOSE = nil
    TT::Lib.reload if tt_lib
    # Core file (this)
    load __FILE__
    # Supporting files
    if defined?( PATH ) && File.exist?( PATH )
      x = Dir.glob( File.join(PATH, '*.{rb,rbs}') ).each { |file|
        load file
      }
      x.length + 1
    else
      1
    end
  ensure
    $VERBOSE = original_verbose
  end

end # module

end # if TT_Lib

#-------------------------------------------------------------------------------

file_loaded( __FILE__ )

#-------------------------------------------------------------------------------