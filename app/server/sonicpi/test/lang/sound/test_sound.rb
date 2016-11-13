#--
# This file is part of Sonic Pi: http://sonic-pi.net
# Full project source: https://github.com/samaaron/sonic-pi
# License: https://github.com/samaaron/sonic-pi/blob/master/LICENSE.md
#
# Copyright 2013, 2014, 2015, 2016 by Sam Aaron (http://sam.aaron.name).
# All rights reserved.
#
# Permission is granted for use, copying, modification, and
# distribution of modified versions of this work as long as this
# notice is included.
#++

require_relative "../../setup_test"
require_relative "../../../lib/sonicpi/lang/sound"
require 'mocha/setup'
require 'byebug'

module SonicPi
  class SoundTester < Minitest::Test
    class MockStudio
      def initialize(mock_sound_studio, mock_loader, mock_tmp_path)
        @mod_sound_studio = mock_sound_studio
        @sample_loader = mock_loader
        @tmp_path = mock_tmp_path
      end
    end

    def setup
      @mock_sound_studio = Object.new

      @mock_loader = mock()
      @mock_sound = MockStudio.new(@mock_sound_studio, @mock_loader, @mock_tmp_path)
      @mock_sound.extend(Lang::Sound)
      @mock_sound.extend(Lang::Core)
      @mock_sound.stubs(:__stop_other_jobs)
      @mock_sound.stubs(:__info)
      @mock_sound.stubs(:stop)
    end

    def test_rest
      assert_equal(false, @mock_sound.rest?(1))

      assert_equal(true, @mock_sound.rest?(:rest))
      assert_equal(true, @mock_sound.rest?(:r))
      assert_equal(false, @mock_sound.rest?(:norest))

      assert_equal(true, @mock_sound.rest?(nil))

      assert_equal(false, @mock_sound.rest?(Hash.new))

      assert_equal(false, @mock_sound.rest?("a string"))
    end

    def test_truthy
      assert_equal(false, @mock_sound.truthy?(0))
      assert_equal(true, @mock_sound.truthy?(1))
      assert_equal(true, @mock_sound.truthy?(-1))
      assert_equal(true, @mock_sound.truthy?(0.01))

      assert_equal(false, @mock_sound.truthy?(nil))

      assert_equal(true, @mock_sound.truthy?(true))
      assert_equal(false, @mock_sound.truthy?(false))

      proc = Proc.new {true}
      assert_equal(true, @mock_sound.truthy?(proc))
    end

    def test_should_trigger
      h = {on: true, a: 123, c: "d"}
      assert_equal(true, @mock_sound.should_trigger?(h))
      assert_equal(false, h.has_key?(:on))

      h = {on: false, a: 123, c: "d"}
      assert_equal(false, @mock_sound.should_trigger?(h))
      assert_equal(false, h.has_key?(:on))

      h = {a: 123, c: "d"}
      assert_equal(true, @mock_sound.should_trigger?(h))
    end

    def test_symbol_arithmetic
      assert_equal(:d4 - :c4, 2)
      assert_equal(:d4 - 2, 60)
      assert_equal(:r - 2, :r)

      assert_equal(:c4 + :d4, 122)
      assert_equal(:c4 + 2, 62)
      assert_equal(:r + 2, :r)
    end

    def test_symbol_conversion
      assert_equal(:c4.to_f, 60.0)
      assert_equal(:c4.to_i, 60)

      assert_equal(:r.to_f, 0.0)
      assert_equal(:r.to_i, 0)
    end

    def test_nil_arithmetic
      assert_equal(nil - 2, nil)
      assert_equal(nil - :c4, nil)
      assert_equal(nil - nil, nil)

      assert_equal(nil + 2, nil)
      assert_equal(nil + :c4, nil)
      assert_equal(nil + nil, nil)
    end

    def test_current_sample_pack_aliases
      error = assert_raises { @mock_sound.current_sample_pack_aliases }
      assert_match(/no longer supported/, error.message)
    end

    def test_with_sample_pack_as
      error = assert_raises { @mock_sound.with_sample_pack_as }
      assert_match(/no longer supported/, error.message)
    end

    def test_use_sample_pack_as
      error = assert_raises { @mock_sound.use_sample_pack_as }
      assert_match(/no longer supported/, error.message)
    end

    def test_use_sample_pack
      error = assert_raises { @mock_sound.use_sample_pack(nil) }
      assert_match(/no longer supported/, error.message)
    end

    def test_with_sample_pack
      error = assert_raises { @mock_sound.with_sample_pack(nil) }
      assert_match(/no longer supported/, error.message)
    end

    def test_reboot_when_already_rebooting
      @mock_sound_studio.stubs(:rebooting).returns(true)
      @mock_sound_studio.expects(:reboot).never
      @mock_loader.expects(:reset!).returns(nil)

      @mock_sound.reboot
    end

    def test_reboot_when_successful
      @mock_sound_studio.stubs(:rebooting).returns(false)

      @mock_sound_studio.expects(:reboot).returns(true)
      @mock_loader.expects(:reset!).returns(nil)
      @mock_sound.expects(:__info).once.with { |p| p.match('Rebooting') }
      @mock_sound.expects(:__info).once.with { |p| p.match('Reboot successful') }
      @mock_sound.reboot
    end

    def test_reboot_when_unsuccessful
      @mock_sound_studio.stubs(:rebooting).returns(false)

      @mock_sound_studio.expects(:reboot).returns(false)
      @mock_loader.expects(:reset!).returns(nil)
      @mock_sound.expects(:__info).once.with { |p| p.match('Rebooting') }
      @mock_sound.expects(:__info).once.with { |p| p.match('Reboot unsuccessful') }
      @mock_sound.reboot
    end

    def test_scsynth_info
      @mock_sound_studio.expects(:scsynth_info)
      @mock_sound.scsynth_info
    end

    def test_octs_with_start_note_only
      @mock_sound.expects(:note).once.returns(60)
      assert_equal(SonicPi::Core::RingVector.new([60]), @mock_sound.octs(60))
    end

    def test_octs_with_start_note_and_num_octs
      @mock_sound.expects(:note).twice.returns(60)
      assert_equal(SonicPi::Core::RingVector.new([60, 72]), @mock_sound.octs(60, 2))
    end

    def test_octs_with_start_note_and_invalid_num_octs
      @mock_sound.expects(:note).never
      assert_equal(SonicPi::Core::RingVector.new([]), @mock_sound.octs(60, -1))
    end

    def test_sample_free_with_no_args
      assert_equal(@mock_sound.sample_free, [])
    end

    def test_sample_free_with_one_loaded_sample
      @mock_sound.stubs(:resolve_sample_paths).returns(['~/foo'])
      @mock_sound.expects(:sample_loaded?).with('~/foo').returns(true)

      @mock_sound_studio.expects(:free_sample).once
      @mock_sound.expects(:__info).once.with { |p| p.match('Freed sample:') }

      @mock_sound.sample_free(:foo)
    end

    def test_sample_free_with_one_unloaded_sample
      @mock_sound.stubs(:resolve_sample_paths).returns(['~/foo'])
      @mock_sound.expects(:sample_loaded?).with('~/foo').returns(false)

      @mock_sound_studio.expects(:free_sample).never
      @mock_sound.expects(:__info).never

      @mock_sound.sample_free(:foo)
    end

    def test_sample_free_all
      @mock_sound_studio.expects(:free_all_samples)
      @mock_sound.sample_free_all
    end

    def test_midi_notes
      @mock_sound.expects(:note).with(:d3).returns(50)
      @mock_sound.expects(:note).with(:d4).returns(62)
      @mock_sound.expects(:note).with(:d5).returns(74)

      assert_equal(SonicPi::Core::RingVector.new([50, 62, 74]), @mock_sound.midi_notes(:d3, :d4, :d5))
    end

    def test_use_timing_guarantees_with_block
      @mock_sound.expects(:__thread_locals).never
      error = assert_raises { @mock_sound.use_timing_guarantees(true) {} }
      assert_match(/use_timing_guarantees does not work with a do\/end block./, error.message)
    end

    def test_use_timing_guarantees_without_block
      local = mock()
      local.expects(:set).with(:sonic_pi_mod_sound_timing_guarantees, true)
      @mock_sound.expects(:__thread_locals).returns(local)
      @mock_sound.use_timing_guarantees(true)
    end

    def test_with_timing_guarantees_with_block
      local = mock()
      local.expects(:get).with(:sonic_pi_mod_sound_timing_guarantees).returns(false)
      block = sequence('block')
      local.expects(:set).with(:sonic_pi_mod_sound_timing_guarantees, true).in_sequence(block)
      local.expects(:set).with(:sonic_pi_mod_sound_timing_guarantees, false).in_sequence(block)
      @mock_sound.expects(:__thread_locals).at_least(3).returns(local)
      assert_equal(@mock_sound.with_timing_guarantees(true) { 42 }, 42)
    end

    def test_with_timing_guarantees_without_block
      @mock_sound.expects(:__thread_locals).never
      error = assert_raises { @mock_sound.with_timing_guarantees(true) }
      assert_match(/with_timing_guarantees requires a do\/end block./, error.message)
    end

    def test_use_external_synths_with_block
      @mock_sound.expects(:__thread_locals).never
      error = assert_raises { @mock_sound.use_external_synths(true) {} }
      assert_match(/use_external_synths does not work with a do\/end block./, error.message)
    end

    def test_use_external_synths_without_block
      local = mock()
      local.expects(:set).with(:sonic_pi_mod_sound_use_external_synths, true)
      @mock_sound.expects(:__thread_locals).returns(local)
      @mock_sound.use_external_synths(true)
    end

    def test_use_timing_warnings_with_block
      @mock_sound.expects(:__thread_locals).never
      error = assert_raises { @mock_sound.use_timing_warnings(true) {} }
      assert_match(/use_timing_warnings does not work with a do\/end block./, error.message)
    end

    def test_use_timing_warnings_without_block
      local = mock()
      local.expects(:set).with(:sonic_pi_mod_sound_disable_timing_warnings, false)
      @mock_sound.expects(:__thread_locals).returns(local)
      @mock_sound.use_timing_warnings(true)
    end

    def test_with_timing_warnings_with_block
      local = mock()
      local.expects(:get).with(:sonic_pi_mod_sound_disable_timing_warnings).returns(true)
      block = sequence('block')
      local.expects(:set).with(:sonic_pi_mod_sound_disable_timing_warnings, false).in_sequence(block)
      local.expects(:set).with(:sonic_pi_mod_sound_disable_timing_warnings, true).in_sequence(block)
      @mock_sound.expects(:__thread_locals).at_least(3).returns(local)
      assert_equal(@mock_sound.with_timing_warnings(true) { 42 }, 42)
    end

    def test_with_timing_warnings_without_block
      @mock_sound.expects(:__thread_locals).never
      error = assert_raises { @mock_sound.with_timing_warnings(true) }
      assert_match(/with_timing_warnings requires a do\/end block./, error.message)
    end

    def test_use_sample_bpm_with_num_beats
      @mock_sound.stubs(:resolve_synth_opts_hash_or_array).returns(num_beats: 2)
      buffer_info = mock()
      buffer_info.stubs(:duration).returns(1)
      @mock_sound.stubs(:sample_buffer).returns(buffer_info)
      @mock_sound.expects(:use_bpm).with(120)
      @mock_sound.use_sample_bpm(:foo, num_beats: 2)
    end

    def test_use_sample_bpm_without_num_beats
      @mock_sound.stubs(:resolve_synth_opts_hash_or_array).returns({})
      buffer_info = mock()
      buffer_info.stubs(:duration).returns(1)
      @mock_sound.stubs(:sample_buffer).returns(buffer_info)
      @mock_sound.expects(:use_bpm).with(60)
      @mock_sound.use_sample_bpm(:foo)
    end

    def test_with_sample_bpm_with_block_and_args
      @mock_sound.stubs(:resolve_synth_opts_hash_or_array).returns(num_beats: 2)
      buffer_info = mock()
      buffer_info.stubs(:duration).returns(1)
      @mock_sound.stubs(:sample_buffer).returns(buffer_info)
      @mock_sound.expects(:with_bpm).with(120).returns(42)
      assert_equal(@mock_sound.with_sample_bpm(:foo, num_beats: 2) {}, 42)
    end

    def test_with_sample_bpm_with_block_and_no_args
      @mock_sound.stubs(:resolve_synth_opts_hash_or_array).returns({})
      buffer_info = mock()
      buffer_info.stubs(:duration).returns(1)
      @mock_sound.stubs(:sample_buffer).returns(buffer_info)
      @mock_sound.expects(:with_bpm).with(60).returns(42)
      assert_equal(@mock_sound.with_sample_bpm(:foo) {}, 42)
    end

    def test_with_sample_bpm_without_block
      @mock_sound.expects(:with_bpm).never
      error = assert_raises { @mock_sound.with_sample_bpm(:foo, num_beats: 2) }
      assert_match(/with_sample_bpm must be called with a do\/end block/, error.message)
    end

    def test_use_arg_bpm_scaling_with_block
      @mock_sound.expects(:__thread_locals).never
      error = assert_raises { @mock_sound.use_arg_bpm_scaling(true) {} }
      assert_match(/use_arg_bpm_scaling does not work with a block./, error.message)
    end

    def test_use_arg_bpm_scaling_without_block
      local = mock()
      local.expects(:set).with(:sonic_pi_spider_arg_bpm_scaling, true)
      @mock_sound.expects(:__thread_locals).returns(local)
      @mock_sound.use_arg_bpm_scaling(true)
    end

    def test_with_arg_bpm_scaling_with_block
      local = mock()
      local.expects(:get).with(:sonic_pi_spider_arg_bpm_scaling).returns(false)
      block = sequence('block')
      local.expects(:set).with(:sonic_pi_spider_arg_bpm_scaling, true).in_sequence(block)
      local.expects(:set).with(:sonic_pi_spider_arg_bpm_scaling, false).in_sequence(block)
      @mock_sound.expects(:__thread_locals).at_least(3).returns(local)
      assert_equal(@mock_sound.with_arg_bpm_scaling(true) { 42 }, 42)
    end

    def test_with_arg_bpm_scaling_without_block
      @mock_sound.expects(:__thread_locals).never
      error = assert_raises { @mock_sound.with_arg_bpm_scaling(true) }
      assert_match(/with_arg_bpm_scaling must be called with a do\/end block./, error.message)
    end

    def test_pitch_ratio
      error = assert_raises { @mock_sound.pitch_ratio(nil) }
      assert_match(/The fn pitch_ratio has been renamed./, error.message)
    end

    def test_ratio_to_pitch
      assert_equal(@mock_sound.ratio_to_pitch(2), 12)
      assert_equal(@mock_sound.ratio_to_pitch(-2), 12)
      assert_equal(@mock_sound.ratio_to_pitch(0.5), -12)
    end

    def test_midi_to_hz
      assert_in_delta(@mock_sound.midi_to_hz(60), 261.6256, 0.001)
    end

    def test_hz_to_midi
      assert_in_delta(@mock_sound.hz_to_midi(261.63), 60.0003, 0.001)
    end

    def test_set_recording_bit_depth!
      @mock_sound_studio.expects(:bit_depth=).with(24)
      @mock_sound.expects(:__info).once.with('Recording bit depth set to 24')
      @mock_sound.set_recording_bit_depth!(24)
    end

    def test_set_control_delta!
      @mock_sound_studio.expects(:control_delta=).with(0.1)
      @mock_sound.expects(:__info).once.with('Control delta set to 0.1')
      @mock_sound.set_control_delta!(0.1)
    end

    def test_set_sched_ahead_time!
      @mock_sound_studio.expects(:sched_ahead_time=).with(1)
      @mock_sound.expects(:__info).once.with('Schedule ahead time set to 1')
      @mock_sound.set_sched_ahead_time!(1)
    end

    def test_use_debug_with_block
      @mock_sound.expects(:__thread_locals).never
      error = assert_raises { @mock_sound.use_debug(true) {} }
      assert_match(/use_debug does not work with a do\/end block./, error.message)
    end

    def test_use_debug_without_block
      local = mock()
      local.expects(:set).with(:sonic_pi_mod_sound_synth_silent, false)
      @mock_sound.expects(:__thread_locals).returns(local)
      @mock_sound.use_debug(true)
    end

    def test_with_debug_with_block
      local = mock()
      local.expects(:get).with(:sonic_pi_mod_sound_synth_silent).returns(true)
      block = sequence('block')
      local.expects(:set).with(:sonic_pi_mod_sound_synth_silent, false).in_sequence(block)
      local.expects(:set).with(:sonic_pi_mod_sound_synth_silent, true).in_sequence(block)
      @mock_sound.expects(:__thread_locals).at_least(3).returns(local)
      assert_equal(@mock_sound.with_debug(true) { 42 }, 42)
    end

    def test_with_debug_without_block
      @mock_sound.expects(:__thread_locals).never
      error = assert_raises { @mock_sound.with_debug(true) }
      assert_match(/with_debug requires a do\/end block./, error.message)
    end

    def test_use_arg_checks_with_block
      @mock_sound.expects(:__thread_locals).never
      error = assert_raises { @mock_sound.use_arg_checks(true) {} }
      assert_match(/use_arg_checks does not work with a do\/end block./, error.message)
    end

    def test_use_arg_checks_without_block
      local = mock()
      local.expects(:set).with(:sonic_pi_mod_sound_check_synth_args, true)
      @mock_sound.expects(:__thread_locals).returns(local)
      @mock_sound.use_arg_checks(true)
    end

    def test_with_arg_checks_with_block
      local = mock()
      local.expects(:get).with(:sonic_pi_mod_sound_check_synth_args).returns(false)
      block = sequence('block')
      local.expects(:set).with(:sonic_pi_mod_sound_check_synth_args, true).in_sequence(block)
      local.expects(:set).with(:sonic_pi_mod_sound_check_synth_args, false).in_sequence(block)
      @mock_sound.expects(:__thread_locals).at_least(3).returns(local)
      assert_equal(@mock_sound.with_arg_checks(true) { 42 }, 42)
    end

    def test_with_arg_checks_without_block
      @mock_sound.expects(:__thread_locals).never
      error = assert_raises { @mock_sound.with_arg_checks(true) }
      assert_match(/with_arg_checks requires a do\/end block./, error.message)
    end

    def test_set_cent_tuning!
      @mock_sound_studio.expects(:cent_tuning=).with(1)
      @mock_sound.set_cent_tuning!(1)
    end

    def test_use_cent_tuning_with_block
      @mock_sound.expects(:__thread_locals).never
      error = assert_raises { @mock_sound.use_cent_tuning(1) {} }
      assert_match(/use_cent_tuning does not work with a do\/end block./, error.message)
    end

    def test_use_cent_tuning_without_block
      local = mock()
      local.expects(:set).with(:sonic_pi_mod_sound_cent_tuning, 1)
      @mock_sound.expects(:__thread_locals).returns(local)
      @mock_sound.use_cent_tuning(1)
    end

    def test_use_cent_tuning_without_block_but_invalid_shift
      @mock_sound.expects(:__thread_locals).never
      error = assert_raises { @mock_sound.use_cent_tuning(:r) }
      assert_match(/Cent tuning value must be a number/, error.message)
    end

    def test_with_cent_tuning_with_block
      local = mock()
      local.expects(:get).with(:sonic_pi_mod_sound_cent_tuning).returns(0)
      block = sequence('block')
      local.expects(:set).with(:sonic_pi_mod_sound_cent_tuning, 1).in_sequence(block)
      local.expects(:set).with(:sonic_pi_mod_sound_cent_tuning, 0).in_sequence(block)
      @mock_sound.expects(:__thread_locals).at_least(3).returns(local)
      assert_equal(@mock_sound.with_cent_tuning(1) { 42 }, 42)
    end

    def test_with_cent_tuning_with_block_but_invalid_shift
      @mock_sound.expects(:__thread_locals).never
      error = assert_raises { @mock_sound.with_cent_tuning(:r) {} }
      assert_match(/Cent tuning value must be a number/, error.message)
    end

    def test_with_cent_tuning_without_block
      @mock_sound.expects(:__thread_locals).never
      error = assert_raises { @mock_sound.with_cent_tuning(1) }
      assert_match(/with_cent_tuning requires a do\/end block./, error.message)
    end

    def test_use_octave_with_block
      @mock_sound.expects(:__thread_locals).never
      error = assert_raises { @mock_sound.use_octave(1) {} }
      assert_match(/use_octave does not work with a do\/end block./, error.message)
    end

    def test_use_octave_without_block
      local = mock()
      local.expects(:set).with(:sonic_pi_mod_sound_octave_shift, 1)
      @mock_sound.expects(:__thread_locals).returns(local)
      @mock_sound.use_octave(1)
    end

    def test_use_octave_without_block_but_invalid_shift
      @mock_sound.expects(:__thread_locals).never
      error = assert_raises { @mock_sound.use_octave(:r) }
      assert_match(/Octave shift must be a number/, error.message)
    end

    def test_with_octave_with_block
      local = mock()
      local.expects(:get).with(:sonic_pi_mod_sound_octave_shift).returns(0)
      block = sequence('block')
      local.expects(:set).with(:sonic_pi_mod_sound_octave_shift, 1).in_sequence(block)
      local.expects(:set).with(:sonic_pi_mod_sound_octave_shift, 0).in_sequence(block)
      @mock_sound.expects(:__thread_locals).at_least(3).returns(local)
      assert_equal(@mock_sound.with_octave(1) { 42 }, 42)
    end

    def test_with_octave_with_block_but_invalid_shift
      @mock_sound.expects(:__thread_locals).never
      error = assert_raises { @mock_sound.with_octave(:r) {} }
      assert_match(/Octave shift must be a number/, error.message)
    end

    def test_with_octave_without_block
      @mock_sound.expects(:__thread_locals).never
      error = assert_raises { @mock_sound.with_octave(1) }
      assert_match(/with_octave requires a do\/end block./, error.message)
    end

    def test_use_transpose_with_block
      @mock_sound.expects(:__thread_locals).never
      error = assert_raises { @mock_sound.use_transpose(1) {} }
      assert_match(/use_transpose does not work with a do\/end block./, error.message)
    end

    def test_use_transpose_without_block
      local = mock()
      local.expects(:set).with(:sonic_pi_mod_sound_transpose, 1)
      @mock_sound.expects(:__thread_locals).returns(local)
      @mock_sound.use_transpose(1)
    end

    def test_use_transpose_without_block_but_invalid_shift
      @mock_sound.expects(:__thread_locals).never
      error = assert_raises { @mock_sound.use_transpose(:r) }
      assert_match(/Transpose value must be a number/, error.message)
    end

    def test_with_transpose_with_block
      local = mock()
      local.expects(:get).with(:sonic_pi_mod_sound_transpose).returns(0)
      block = sequence('block')
      local.expects(:set).with(:sonic_pi_mod_sound_transpose, 1).in_sequence(block)
      local.expects(:set).with(:sonic_pi_mod_sound_transpose, 0).in_sequence(block)
      @mock_sound.expects(:__thread_locals).at_least(3).returns(local)
      assert_equal(@mock_sound.with_transpose(1) { 42 }, 42)
    end

    def test_with_transpose_with_block_but_invalid_shift
      @mock_sound.expects(:__thread_locals).never
      error = assert_raises { @mock_sound.with_transpose(:r) {} }
      assert_match(/Transpose value must be a number/, error.message)
    end

    def test_with_transpose_without_block
      @mock_sound.expects(:__thread_locals).never
      error = assert_raises { @mock_sound.with_transpose(1) }
      assert_match(/with_transpose requires a do\/end block./, error.message)
    end

    def test_use_tuning_with_block
      @mock_sound.expects(:__thread_locals).never
      error = assert_raises { @mock_sound.use_tuning(:just, :c) {} }
      assert_match(/use_tuning does not work with a do\/end block./, error.message)
    end

    def test_use_tuning_without_block
      local = mock()
      local.expects(:set).with(:sonic_pi_mod_sound_tuning, [:just, :c])
      @mock_sound.expects(:__thread_locals).returns(local)
      @mock_sound.use_tuning(:just, :c)
    end

    def test_use_tuning_without_block_but_invalid_value
      @mock_sound.expects(:__thread_locals).never
      error = assert_raises { @mock_sound.use_tuning(1, :c) }
      assert_match(/tuning value must be a symbol/, error.message)
    end

    def test_use_synth_with_block
      @mock_sound.expects(:set_current_synth).never
      error = assert_raises { @mock_sound.use_synth(:beep) {} }
      assert_match(/use_synth does not work with a do\/end block./, error.message)
    end

    def test_use_synth_with_args
      @mock_sound.expects(:set_current_synth).never
      error = assert_raises { @mock_sound.use_synth(:beep, amp: 1) }
      assert_match(/use_synth does not accept opts such as/, error.message)
    end

    def test_use_synth_without_block
      @mock_sound.expects(:set_current_synth).with(:beep)
      @mock_sound.use_synth(:beep)
    end

    def test_with_synth_with_block
      @mock_sound.expects(:current_synth_name).returns(:beep)
      block = sequence('block')
      @mock_sound.expects(:set_current_synth).with(:saw).in_sequence(block)
      @mock_sound.expects(:set_current_synth).with(:beep).in_sequence(block)
      assert_equal(@mock_sound.with_synth(:saw) { 42 }, 42)
    end

    def test_with_synth_with_block_and_args
      @mock_sound.expects(:set_current_synth).never
      error = assert_raises { @mock_sound.with_synth(:saw, amp: 1) {} }
      assert_match(/with_synth does not accept opts such as/, error.message)
    end

    def test_with_synth_without_block
      @mock_sound.expects(:set_current_synth).never
      error = assert_raises { @mock_sound.with_synth(:saw) }
      assert_match(/with_synth must be called with a do\/end block./, error.message)
    end

    def test_recording_start_when_already_recording
      @mock_sound_studio.stubs(:recording?).returns(true)
      @mock_sound.expects(:__info).with('Already recording...')
      @mock_sound_studio.expects(:recording_start).never
      @mock_sound.recording_start
    end

    def test_recording_start
      @mock_sound_studio.stubs(:recording?).returns(false)
      @mock_sound.expects(:__info).with('Start recording')
      @mock_sound_studio.expects(:recording_start)
      @mock_sound.recording_start
    end

    def test_recording_stop
      @mock_sound_studio.stubs(:recording?).returns(true)
      @mock_sound.expects(:__info).with('Stop recording')
      @mock_sound_studio.expects(:recording_stop)
      @mock_sound.recording_stop
    end

    def test_recording_stop_when_not_recording
      @mock_sound_studio.stubs(:recording?).returns(false)
      @mock_sound.expects(:__info).with('Recording already stopped')
      @mock_sound_studio.expects(:recording_stop).never
      @mock_sound.recording_stop
    end

    def test_recording_save_when_not_recording
      @mock_sound_studio.stubs(:recording_stop).returns(false)
      @mock_sound.expects(:__info).with { |p| p.match('Stop recording') }.never
      @mock_sound.recording_save('foo.wav')
    end

    def test_recording_save_when_recording
      @mock_sound_studio.stubs(:recording_stop).returns(true)
      @mock_sound.expects(:__info).with { |p| p.match('Stop recording') }
      @mock_sound.recording_save('foo.wav')
    end

    def test_recording_save_when_tmp_path_is_not_nil
      @mock_tmp_path = '/tmp/sonic-pi/1.wav'
      setup

      @mock_sound_studio.stubs(:recording_stop).returns(false)
      File.stubs(:exists?).returns(true)
      FileUtils.stubs(:mv)
      filename = 'foo.wav'

      @mock_sound.expects(:__info).with { |p| p.match('Stop recording') }.never
      @mock_sound.expects(:__info).with { |p| p.match("Saving recording to #{filename}") }
      @mock_sound.recording_save(filename)
    end

    def test_recording_save_when_tmp_path_is_nil
      @mock_sound_studio.stubs(:recording_stop).returns(false)
      FileUtils.stubs(:mv)
      filename = 'foo.wav'

      @mock_sound.expects(:__info).with { |p| p.match('No recording to save') }
      @mock_sound.recording_save(filename)
    end

    def test_recording_delete_when_tmp_path_is_not_nil
      @mock_tmp_path = '/tmp/sonic-pi/1.wav'
      setup

      @mock_sound.expects(:__info).with('Deleting recording...')
      FileUtils.expects(:rm).with(@mock_tmp_path)
      @mock_sound.recording_delete
    end

    def test_recording_delete_when_tmp_path_is_nil
      @mock_sound.expects(:__info).with('Deleting recording...')
      FileUtils.expects(:rm).with(@mock_tmp_path).never
      @mock_sound.recording_delete
    end

    def test_reset_mixer!
      @mock_sound_studio.expects(:mixer_reset)
      @mock_sound.reset_mixer!
    end

    def test_set_mixer_control!
      opts = {}
      @mock_sound_studio.expects(:mixer_control).with(opts)
      @mock_sound.set_mixer_control!(opts)
    end

    def test_set_mixer_invert_stereo!
      @mock_sound_studio.expects(:mixer_invert_stereo).with(true)
      @mock_sound.set_mixer_invert_stereo!
    end

    def test_set_mixer_standard_stereo!
      @mock_sound_studio.expects(:mixer_invert_stereo).with(false)
      @mock_sound.set_mixer_standard_stereo!
    end

    def test_set_mixer_stereo_mode!
      @mock_sound_studio.expects(:mixer_stereo_mode)
      @mock_sound.set_mixer_stereo_mode!
    end

    def test_set_mixer_mono_mode!
      @mock_sound_studio.expects(:mixer_mono_mode)
      @mock_sound.set_mixer_mono_mode!
    end
  end
end
