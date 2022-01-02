"./makeFX.scd".loadRelative;

~makeFX.value("sonic-pi-fx_chorus", {
  |dry_l, dry_r,
  buf_num = 0,
  phase = 0.5, phase_slide = 0, phase_slide_shape = 1, phase_slide_curve = 0, max_phase = 1,
  decay = 0.00001, decay_slide = 0, decay_slide_shape = 1, decay_slide_curve = 0|
  var new_l, new_r;

  phase = VarLag.kr(phase, phase_slide, phase_slide_curve, phase_slide_shape);
  decay = VarLag.kr(decay, decay_slide, decay_slide_curve, decay_slide_shape);

  # new_l, new_r = [dry_l, dry_r] + BufCombN.ar(buf_num, [dry_l, dry_r], [SinOsc.ar(0.0004), SinOsc.ar(0.0001 * (phase + 0.4))], decay);
}, [], 2);