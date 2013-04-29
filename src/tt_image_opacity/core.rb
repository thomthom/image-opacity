#-----------------------------------------------------------------------------
# Version: 1.0.0
# Compatible: SketchUp 7 (PC)
#             (other versions untested)
#-----------------------------------------------------------------------------
#
# CHANGELOG
# 1.0.0 - 30.08.2010
#		 * Initial release.
#
#-----------------------------------------------------------------------------
#
# Thomas Thomassen
# thomas[at]thomthom[dot]net
#
#-----------------------------------------------------------------------------

require 'sketchup.rb'
require 'TT_Lib2/core.rb'

TT::Lib.compatible?('2.0.0', 'TT Image Opacity')

#-----------------------------------------------------------------------------

module TT::Plugins::ImageOpacity  
  
  ### MENU & TOOLBARS ### --------------------------------------------------
  
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
  
  
  ### MAIN SCRIPT ### ------------------------------------------------------
  
  
  # Modifies the selected Image's transparancy
  def self.set_image_opacity(opacity = 0)
    image = Sketchup.active_model.selection.first
    material = TT::Image.material( image )
    material.alpha = opacity / 100.0
  end
  
  
  def self.get_image_opacity
    image = Sketchup.active_model.selection.first
    material = TT::Image.material( image )
    material.alpha * 100.0
  end
  
  
  ### DEBUG ### ------------------------------------------------------------
  
  def self.reload
    load __FILE__
  end
  
end # module

#-----------------------------------------------------------------------------
file_loaded( File.basename(__FILE__) )
#-----------------------------------------------------------------------------